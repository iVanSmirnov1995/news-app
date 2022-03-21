//
//  NewslinePresenter.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

final class NewslinePresenter {

    // MARK: - Internal properties

    var interactor: NewslineInteractorInput?
    var moduleOutput: NewslineModuleOutput?
    weak var viewInput: NewslineViewInput?

    // MARK: - Init

    private var newsWithSourceModels: [NewsWithSourceModel] = []

    // MARK: - Init

    init(interactor: NewslineInteractorInput, moduleOutput: NewslineModuleOutput) {
        self.moduleOutput = moduleOutput
        self.interactor = interactor
    }

    // MARK: - Private

    private func setupSettingsNavBarItem() {
        self.viewInput?.setupSettingsNavBarItem(buttonTitle: "Settings")
    }

    private func loadData(sources: [String]) {
        self.interactor?.loadNewslineRSSModels(sources: sources, then: { result in
            let errors = result.errors
            if !errors.isEmpty {
                let titleAlert = errors
                    .compactMap { $0.errorSourceName }
                    .joined(separator: ", ")
                self.moduleOutput?.needOpenAlert(title: "\(titleAlert) loaded uncorrect")
            }
            let newsWithSourceModels = result.models.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
            self.newsWithSourceModels = newsWithSourceModels
            self.setupShortDisplayViewModel()
        })
    }

    private func registerForNotifications() {
        SourcesManager.shared.addChangeStatusHandler { [weak self] sources in
            guard let self = self else { return false }
            self.loadData(sources: sources)
            return true
        }

        UpdateTimerManager.shared.addUpdateHandler { [weak self] _ in
            guard let self = self else { return false }
            self.loadData(sources: SourcesManager.shared.selectedSources)
            return true
        }
    }

    private func setupShortDisplayViewModel() {
        let loadSaveNews = self.interactor?.loadSaveNews()
        let newsShortDisplayViewModel = self.newsWithSourceModels.compactMap { model -> NewsShortDisplayViewModel in
            loadSaveNews?.contains(where: { $0.isEqual(to: model) }) ?? false
            ? model.convertToReadNewsShortDisplayViewModel()
            : model.convertToNoReadNewsShortDisplayViewModel()
        }
        self.viewInput?.setupModels(models: newsShortDisplayViewModel)
    }
}

// MARK: - NewslineViewOutput

extension NewslinePresenter: NewslineViewOutput {
    func didSelectCell(index: Int) {
        guard let newsWithSourceModels = self.newsWithSourceModels[safe: index] else { return }
        let newsDeployedViewModel = newsWithSourceModels.convertToStandartNewsDeployedViewModel()
        self.moduleOutput?.needOpenDetailedNewsScreen(newsDeployedModel: newsDeployedViewModel)
        self.interactor?.saveReadNews(model: newsWithSourceModels, then: { _ in })
    }

    func didTapSettingsButton() {
        self.moduleOutput?.needOpenSettings()
    }

    func viewDidLoad() {
        self.setupSettingsNavBarItem()
        self.registerForNotifications()
        self.loadData(sources: SourcesManager.shared.selectedSources)
    }
}

// MARK: - NewslineModuleInput

extension NewslinePresenter: NewslineModuleInput {
    func updateUploadedData() {
        self.setupShortDisplayViewModel()
    }
}
