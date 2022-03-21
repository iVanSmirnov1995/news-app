//
//  RSSNewsDeployedViewModel.swift
//  News
//
//  Created by Иван Смирнов on 24.03.2022.
//

import Foundation

/// Описывает новость, на экране детальной новости
protocol NewsDeployedViewModel {
    var title: String { get }
    var date: Date { get }
    var imageURLString: String? { get }
    var description: String? { get }
    var source: String { get }
}

/// Структура для разширенного отображения новости
struct StandartNewsDeployedViewModel: NewsDeployedViewModel {
    let title: String
    let date: Date
    let imageURLString: String?
    let description: String?
    let source: String
}
