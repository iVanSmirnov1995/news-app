//
//  UpdateManager.swift
//  News
//
//  Created by Иван Смирнов on 28.03.2022.
//

import Foundation

/// Кложура для использования в эмиттере, который рассылает сообщение
typealias UpdateHandlerClosure = (TimeInterval) -> ShouldContinueReceiveNotifications

/// Менеджер, который отвечает обновление данных по таймеру
final class UpdateTimerManager {

    // MARK: - Internal properties

    static let shared = UpdateTimerManager()

    /// Время, через которое таймер должен обновляться.
    private (set) var updateTimeInterval: TimeInterval?

    // MARK: - Private properties

    private var checkTimer: Timer?

    private var updateEmitter = Emitter<TimeInterval>()

    private let userDefaultsUpdateTimeIntervalKey = "userDefaultsUpdateTimeIntervalKey"
    
    // MARK: - Internal methods
    
    /// Стартует менеджер.
    func start() {
        self.setupStartTimeInterval()
        self.updateInactiveSources()
    }

    /// Позволяет подписаться на уведомление о том, что данные нужно обновить
    ///
    /// - Parameter closure: Замыкание, которое будет вызываться при сробатывании таймера.
    func addUpdateHandler(_ closure: @escaping UpdateHandlerClosure) {
        self.updateEmitter.addReaction {
            return closure($0)
        }
    }

    /// Установить новый период срабатывания таймера
    /// - Parameter time: Период срабатывания
    func setupUpdateTime(time: TimeInterval) {
        UserDefaults.standard.set(time, forKey: self.userDefaultsUpdateTimeIntervalKey)
        self.updateTimeInterval = time
        self.updateInactiveSources()
    }

    // MARK: - Private methods

    private func setupStartTimeInterval() {
        guard let time = UserDefaults
                .standard
                .object(forKey: self.userDefaultsUpdateTimeIntervalKey) as? TimeInterval else {
                    let defaultsTimeInterval = 30.0
                    UserDefaults.standard.set(defaultsTimeInterval, forKey: self.userDefaultsUpdateTimeIntervalKey)
                    self.updateTimeInterval = defaultsTimeInterval
                    self.setupStartTimeInterval()
                    return
                }
        self.updateTimeInterval = time
    }

    private func updateInactiveSources() {
        self.checkTimer?.invalidate()
        guard let updateTimeInterval = self.updateTimeInterval else { return }
        self.checkTimer = Timer.scheduledTimer(withTimeInterval: updateTimeInterval,
                                                           repeats: true,
                                                           block: { [weak self] _ in
            guard let self = self else { return }
            self.updateEmitter.invoke(updateTimeInterval)
        })
    }
}
