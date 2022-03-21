//
//  TimingModel.swift
//  News
//
//  Created by Ivan Smirnov on 27.03.2022.
//

import Foundation

/// Модель данных, для выбора времени
struct TimingModel {
    // MARK: - Internal properties

    /// Масиив заголовков для UI возможных временных обновлений
    let updateTimesTitle: [String]
    /// Масиив возможных временных обновлений
    let updateTimes: [TimeInterval]
    /// Текущее выбранное врямя обновления
    let currentIndex: Int

    // MARK: - Init

    init(minTime: TimeInterval, offset: TimeInterval, count: Int, chosenTime: TimeInterval) {
        self.updateTimes = (0 ... count - 1)
            .compactMap { minTime + TimeInterval($0) * offset }
        self.updateTimesTitle = self.updateTimes.compactMap { "\($0)" }
        self.currentIndex = self.updateTimes.firstIndex(of: chosenTime) ?? 0
    }
}
