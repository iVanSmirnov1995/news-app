//
//  SettingsPresenter.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

final class DetailedNewsPresenter {

    // MARK: - Internal properties

    weak var moduleOutput: DetailedNewsModuleOutput?
    weak var viewInput: DetailedNewsViewInput?

    // MARK: - Private properties

    private let model: NewsDeployedViewModel

    // MARK: - Init

    init(moduleOutput: DetailedNewsModuleOutput, model: NewsDeployedViewModel) {
        self.moduleOutput = moduleOutput
        self.model = model
    }
}

// MARK: - DetailedNewsViewOutput

extension DetailedNewsPresenter: DetailedNewsViewOutput {
    func viewControllerIsRemoving() {
        self.moduleOutput?.userDidFinishFlow()
    }

    func viewDidLoad() {
        self.viewInput?.setupViewModel(model: self.model)
    }
}
