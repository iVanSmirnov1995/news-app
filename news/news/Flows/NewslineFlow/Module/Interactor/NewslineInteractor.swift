//
//  NewslineInteractor.swift
//  News
//
//  Created by Ivan Smirnov on 23.03.2022.
//

import Foundation
import RealmSwift
import UIKit

/// Интерактор модуля списка новостей.
final class NewslineInteractor {

    private typealias RSSWithSourceModelClosure = (Result<[RSSWithSourceModel], NewslineInteractorError>) -> Void

    // MARK: - Private properties

    private let apiProvider: APIProviderProtocol
    private let realm = try? Realm()

    // MARK: - Init

    init(apiProvider: APIProviderProtocol = APIProvider()) {
        self.apiProvider = apiProvider
    }

    // MARK: - Private

    private func loadNewslineRSSModel(source: String, then completion: @escaping RSSWithSourceModelClosure) {
        self.apiProvider.dataRequest(with: source, objectType: RSSModel.self) { result in
            switch result {
            case .success(let model):
                let rssWithSourceModel = model.convertToRSSWithSourceModels()
                completion(.success(rssWithSourceModel))
            case .failure:
                completion(.failure(.init(errorSourceName: source)))
            }
        }
    }
}

// MARK: - NewslineInteractorInput

extension NewslineInteractor: NewslineInteractorInput {

    func loadNewslineRSSModels(sources: [String], then completion: @escaping NewslineRSSInfoClosure) {
        var newsModels: [RSSWithSourceModel] = []
        var errors: [NewslineInteractorError] = []
        let dispatchGroup = DispatchGroup()
        sources.forEach {
            dispatchGroup.enter()
            self.loadNewslineRSSModel(source: $0, then: { result in
                switch result {
                case .success(let models):
                    newsModels += models
                    dispatchGroup.leave()
                case .failure(let error):
                    errors.append(error)
                    dispatchGroup.leave()
                }
            })
        }
        dispatchGroup.notify(queue: .main) {
            completion((newsModels, errors))
        }
    }

    func saveReadNews(model: NewsWithSourceModel, then completion: ((Result<(), Error>) -> Void)) {
        do {
            try self.realm?.write {
                let model = model.managedObject()
                self.realm?.add(model)
                completion(.success(()))
            }

        } catch {
            completion(.failure(RealmError(description: "write error")))
        }
    }

    func loadSaveNews() -> [NewsWithSourceModel]? {
        self.realm?
            .objects(NewsForRealm.self)
            .map { model -> NewsWithSourceModel in model }
    }
}
