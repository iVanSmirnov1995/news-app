//
//  SettingsPresenter.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

final class SettingsPresenter {

    // MARK: - Internal properties

    weak var moduleOutput: SettingsModuleOutput?
    weak var viewInput: SettingsViewInput?

    // MARK: - Private properties

    private var stateSources: [StateTitleSources] = []
    private var updateTimes: [TimeInterval] = []
    private var chosenUpdateTime: TimeInterval?

    // MARK: - Init

    init(moduleOutput: SettingsModuleOutput) {
        self.moduleOutput = moduleOutput
    }

    // MARK: - Private methods

    private func updateSourcesState() {
        let sourceSettingModel = SourceSettingModel(availableSourcesURLs: SourcesManager.shared.availableSourcesURLs,
                                                    inactiveSourcesURLs: SourcesManager.shared.inactiveSourcesURLs)
        self.stateSources = sourceSettingModel.stateSources
        self.viewInput?.setupSourcesTitles(titles: sourceSettingModel.cellTitles)
    }

    private func setupUpdateTimingTitle() {
        guard let chosenTime = UpdateTimerManager.shared.updateTimeInterval else { return }
        let timingModel = TimingModel(minTime: 30,
                                      offset: 10,
                                      count: 4,
                                      chosenTime: chosenTime)
        self.updateTimes = timingModel.updateTimes
        self.viewInput?.setupUpdateTimesTitles(titles: timingModel.updateTimesTitle,
                                               chosenIndex: timingModel.currentIndex)
    }
}

// MARK: - SettingsViewOutput

extension SettingsPresenter: SettingsViewOutput {
    func didSelectPickerCellIndex(index: Int) {
        self.chosenUpdateTime = self.updateTimes[safe: index]
    }

    func didSelectCellIndex(index: Int) {
        guard let stateSource = self.stateSources[safe: index] else { return }
        self.viewInput?.tabelViewTapIsEnabled(isEnabled: false)
        let complition: ((Result<(), Error>) -> Void) = { [weak self] result in
            switch result {
            case .success:
                self?.updateSourcesState()
                self?.viewInput?.tabelViewTapIsEnabled(isEnabled: true)
            case .failure:
                self?.viewInput?.tabelViewTapIsEnabled(isEnabled: true)
            }
        }
        if stateSource.isActive {
            SourcesManager
                .shared
                .addInactiveSource(source: stateSource.title,
                                   complition: complition)
        } else {
            SourcesManager
                .shared
                .removeInactiveSource(source: stateSource.title,
                                      complition: complition)
        }
    }

    func didTapCloseButton() {
        if let chosenUpdateTime = self.chosenUpdateTime {
            UpdateTimerManager.shared.setupUpdateTime(time: chosenUpdateTime)
        }
        self.moduleOutput?.userDidFinishFlow()
    }

    func viewDidLoad() {
        self.updateSourcesState()
        self.setupUpdateTimingTitle()
    }
}
