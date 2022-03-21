//
//  SourcesManager.swift
//  News
//
//  Created by Ivan Smirnov on 26.03.2022.
//

import Foundation
import RealmSwift

/// Кложура для использования в эмиттере, который рассылает сообщение
typealias UpdateSourcesHandlerClosure = ([String]) -> ShouldContinueReceiveNotifications

/// Менеджер, который отвечает за источники данных
final class SourcesManager {

    // MARK: - Internal properties

    static let shared = SourcesManager()

    /// Выбранные источники данных
    var selectedSources: [String] {
        self.availableSourcesURLs.filter { !self.inactiveSourcesURLs.contains($0) }
    }

    /// Список идентификаторов доступных новостей
    private (set) var availableSourcesURLs: [String] = []

    /// Список идентификаторов неактивных новостей. (по умолчанию все источники активные)
    private (set) var inactiveSourcesURLs: [String] = []

    // MARK: - Private properties

    private let realm = try? Realm()

    private var updateEmitter = Emitter<[String]>()

    // MARK: - Internal methods

    /// Стартует менеджер.
    func start() {
        self.setupStartAvailableSources()
    }

    /// Позволяет подписаться на уведомление о том, что список источников обновился
    ///
    /// - Parameter closure: Замыкание, которое будет вызываться при изменении списка источников.
    func addChangeStatusHandler(_ closure: @escaping UpdateSourcesHandlerClosure) {
        self.updateEmitter.addReaction {
            return closure($0)
        }
    }

    /// Добавить источник в список неактивных
    /// - Parameters:
    ///   - source: Источник
    ///   - complition: Замыкание будет вызвано, когда источник будет добавлен
    func addInactiveSource(source: String, complition: ((Result<(), Error>) -> Void)? = nil) {
        do {
            try self.realm?.write { [weak self] in
                guard let self = self else { return }
                let sourceObject = SourceForRealm()
                sourceObject.urlSrting = source
                self.realm?.add(sourceObject)
                self.invoke()
                complition?(.success(()))
            }
        } catch {
            complition?(.failure(RealmError(description: "write error")))
        }
    }

    /// Удалить источник из списка неактивных
    /// - Parameters:
    ///   - source: Источник
    ///   - complition: Замыкание будет вызвано, когда источник будет удалён
    func removeInactiveSource(source: String, complition: ((Result<(), Error>) -> Void)? = nil) {
        guard let removeObject = self
                .realm?
                .objects(SourceForRealm.self)
                .first(where: { $0.urlSrting == source }) else { return }
        do {
            try self.realm?.write { [weak self] in
                guard let self = self else { return }
                self.realm?.delete(removeObject)
                self.invoke()
                complition?(.success(()))
            }
        } catch {
            complition?(.failure(RealmError(description: "write error")))
        }
    }

    // MARK: - Private methods

    private func setupStartAvailableSources() {
        // В будущем тут может быть загрузка источников(например с сервера)
        self.availableSourcesURLs = ["https://lenta.ru/rss", "https://www.mk.ru/rss/index.xml"]
        self.inactiveSourcesURLs = self.realm?.objects(SourceForRealm.self).map { $0.urlSrting } ?? []
    }

    private func invoke() {
        self.inactiveSourcesURLs = self.realm?.objects(SourceForRealm.self).map { $0.urlSrting } ?? []
        self.updateEmitter.invoke(self.selectedSources)
    }
}
