//
//  SettingsViewInterface.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

protocol SettingsViewInput: AnyObject {
    /// (Активировать / заблокировать) возможность нажатия на ячейки таблицы
    func tabelViewTapIsEnabled(isEnabled: Bool)
    /// Уснановить массив заголовков для списка состояний источников
    func setupSourcesTitles(titles: [String])
    /// Установить массив заголоков для выбора времени обновления и установить индекс текущего индекса
    func setupUpdateTimesTitles(titles: [String], chosenIndex: Int)
}

protocol SettingsViewOutput: ViewOutput {
    /// Была нажата ячейка в списке источников
    func didSelectCellIndex(index: Int)
    /// Было выбранно необходимое время обновления
    func didSelectPickerCellIndex(index: Int)
    /// Была нажата кнопка закрыть
    func didTapCloseButton()
}
