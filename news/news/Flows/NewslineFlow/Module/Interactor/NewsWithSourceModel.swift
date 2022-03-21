//
//  RssWithSourceModel.swift
//  News
//
//  Created by Иван Смирнов on 24.03.2022.
//

import Foundation

/// Описывает модель данных новости с источником.
protocol NewsWithSourceModel {
    var title: String { get }
    var descriptionNews: String? { get }
    var source: String { get }
    var date: Date { get }
    var imageURLString: String? { get }

    func isEqual(to destination: NewsWithSourceModel) -> Bool
}

extension NewsWithSourceModel where Self: Equatable {
    func isEqual(to newsWithSourceModel: NewsWithSourceModel) -> Bool {
        return self.title == newsWithSourceModel.title
        && self.descriptionNews == newsWithSourceModel.descriptionNews
        && self.imageURLString == newsWithSourceModel.imageURLString
        && self.date == newsWithSourceModel.date
        && self.source == newsWithSourceModel.source
    }

}

/// Описывает модель данных `RSS` новости с источником
struct RSSWithSourceModel: NewsWithSourceModel, Equatable {
    let title: String
    let descriptionNews: String?
    let source: String
    let date: Date
    let imageURLString: String?
}

extension NewsWithSourceModel {

    func convertToNoReadNewsShortDisplayViewModel() -> NewsShortDisplayViewModel {
            NoReadNewsShortDisplayViewModel(title: self.title,
                                            dateString: DateHelper.dateStringFromDate(self.date),
                                            imageURLString: self.imageURLString)
    }

    func convertToReadNewsShortDisplayViewModel() -> NewsShortDisplayViewModel {
            ReadNewsShortDisplayViewModel(title: self.title,
                                          dateString: DateHelper.dateStringFromDate(self.date),
                                          imageURLString: self.imageURLString)
    }
}

extension NewsWithSourceModel {
    func convertToStandartNewsDeployedViewModel() -> StandartNewsDeployedViewModel {
        StandartNewsDeployedViewModel(title: self.title,
                                      date: self.date,
                                      imageURLString: self.imageURLString,
                                      description: self.descriptionNews,
                                      source: self.source)
    }
}
