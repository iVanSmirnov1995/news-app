//
//  NewslineModuleInterface.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

protocol NewslineModuleInput {
    /// Обновить загруженные данные
    func updateUploadedData()
}

protocol NewslineModuleOutput: AnyObject {
    /// Необходимо показать алерт ошибки
    func needOpenAlert(title: String)
    /// Открыть модуль настроек.
    func needOpenSettings()
    /// Открыть модуль детального отображения новости
    func needOpenDetailedNewsScreen(newsDeployedModel: NewsDeployedViewModel)
}
