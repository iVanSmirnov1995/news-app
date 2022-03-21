//
//  RSSNewsShortDisplayViewModel.swift
//  News
//
//  Created by Иван Смирнов on 24.03.2022.
//

import Foundation

/// Описывает новость, на экране списка новостей
protocol NewsShortDisplayViewModel {
    var title: String { get }
    var dateString: String { get }
    var imageURLString: String? { get }
    var isRead: Bool { get }
}

/// Структура непрочитанной  новости
struct NoReadNewsShortDisplayViewModel: NewsShortDisplayViewModel {
    let title: String
    let dateString: String
    let imageURLString: String?
    let isRead = false
}

/// Структура прочитанной  новости
struct ReadNewsShortDisplayViewModel: NewsShortDisplayViewModel {
    let title: String
    let dateString: String
    let imageURLString: String?
    let isRead = true
}
