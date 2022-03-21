//
//  NewslineViewInterface.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

protocol NewslineViewInput: AnyObject {

    /// Установить модель данных во вью
    func setupModels(models: [NewsShortDisplayViewModel])

    /// Настроить `navBar` у вью
    func setupSettingsNavBarItem(buttonTitle: String)
}

protocol NewslineViewOutput: ViewOutput {

    /// Сообщает, что была нажата ячейка у таблицы
    func didSelectCell(index: Int)

    /// Сообщает, что была нажата кнопка настройки
    func didTapSettingsButton()
}
