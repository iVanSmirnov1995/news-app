//
//  RssModel.swift
//  News
//
//  Created by Ivan Smirnov on 23.03.2022.
//

import Foundation

/// Структура, которая описывает ответ на запрос "RSS" новости.
struct RSSModel: Decodable {
    /// Массив новостей.
    let newsModels: [News]
    /// Источник новостей.
    let source: String

    enum CodingKeys: String, CodingKey {
        case channel
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let channel = try container.decode(Channel.self, forKey: .channel)
        self.newsModels = channel.item
        self.source = channel.title
    }

    private struct Channel: Decodable {
        let item: [News]
        let title: String
    }
}

/// Структура, которая описывает "RSS" новость.
/// По докоментации  `RSS` любое поле жтой модели может быть опционально.
struct News: Decodable {
    /// Заголовок новости.
    let title: String?
    /// Описание новости
    let description: String?
    /// Дата новсти.
    let date: Date?
    /// Ссылка на картинку новости.
    let imageURLString: String?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case pubDate
        case enclosure
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        if let publicationDate = try container.decodeIfPresent(String.self, forKey: .pubDate) {
            self.date = DateHelper.rssDateFromString(publicationDate)
        } else {
            self.date = nil
        }
        self.imageURLString = try container.decodeIfPresent(Enclosure.self, forKey: .enclosure)?.url
    }

    private struct Enclosure: Decodable {
        let url: String?
    }
}

extension RSSModel {
    func convertToRSSWithSourceModels() -> [RSSWithSourceModel] {
        self.newsModels.compactMap { model -> RSSWithSourceModel? in
            guard let title = model.title, let date = model.date else { return nil }
            return RSSWithSourceModel(title: title,
                                      descriptionNews: model.description,
                                      source: self.source,
                                      date: date,
                                      imageURLString: model.imageURLString)
        }
    }
}
