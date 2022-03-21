//
//  NewslineInteractorInterface.swift
//  News
//
//  Created by Ivan Smirnov on 23.03.2022.
//

import Foundation

/// Псевдоним для замыкания с результатами.
typealias NewslineRSSInfoClosure = ItemClosure<(models: [RSSWithSourceModel], errors: [NewslineInteractorError])>

/// Описывает ошибку, которая  может придти при загрузке данных
struct NewslineInteractorError: Error {
    let errorSourceName: String
}

protocol NewslineInteractorInput {

    /// Загрузить данные `RSS` новостей из нескольких источников.
    func loadNewslineRSSModels(sources: [String],
                               then completion: @escaping NewslineRSSInfoClosure)

    /// Сохранить просмотренную новость
    func saveReadNews(model: NewsWithSourceModel, then completion: ((Result<(), Error>) -> Void))

    /// Загрузить сохраненные новости
    func loadSaveNews() -> [NewsWithSourceModel]?
}
