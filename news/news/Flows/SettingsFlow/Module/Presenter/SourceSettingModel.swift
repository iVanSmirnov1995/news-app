//
//  SourceSettingModel.swift
//  News
//
//  Created by Ivan Smirnov on 27.03.2022.
//

import Foundation

typealias StateTitleSources = (isActive: Bool, title: String )

/// Описывает источник в настройках
struct SourceSettingModel {

    // MARK: - Internal properties

    /// Массив статусов для ui источников
    var cellTitles: [String] {
        self.stateSources.map {
            $0.isActive
            ? "\($0.title) - switched on"
            : "\($0.title) - switched off"
        }
    }

    /// Массив статусовi источников
    var stateSources: [StateTitleSources] {
        self.availableSourcesURLs.map {
            (!self.inactiveSourcesURLs.contains($0), $0)
        }
    }

    // MARK: - Private properties

    private let availableSourcesURLs: [String]
    private let inactiveSourcesURLs: [String]

    // MARK: - Init

    init(availableSourcesURLs: [String], inactiveSourcesURLs: [String]) {
        self.availableSourcesURLs = availableSourcesURLs
        self.inactiveSourcesURLs = inactiveSourcesURLs
    }
}
