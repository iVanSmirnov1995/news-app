//
//  NewsForRealm.swift
//  News
//
//  Created by Ivan Smirnov on 27.03.2022.
//

import Foundation
import RealmSwift

/// Ошибка при работе с БД
struct RealmError: Error {
    let description: String
}

/// Модель для сохранения в БД
final class NewsForRealm: Object, NewsWithSourceModel {
   @objc dynamic var title: String = ""
   @objc dynamic var descriptionNews: String?
   @objc dynamic var source: String = ""
   @objc dynamic var date: Date = Date()
   @objc dynamic var imageURLString: String?
}

extension NewsWithSourceModel {
    func managedObject() -> NewsForRealm {
        let newsForRealm = NewsForRealm()
        newsForRealm.title = title
        newsForRealm.descriptionNews = descriptionNews
        newsForRealm.source = source
        newsForRealm.date = date
        newsForRealm.imageURLString = imageURLString
        return newsForRealm
    }
}
