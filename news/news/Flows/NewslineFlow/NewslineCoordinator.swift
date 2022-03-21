//
//  NewslineCoordinator.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

/// Координатор ленты новостей
final class NewslineCoordinator: CoordinatorProtocol {

    // MARK: - Internal Properties

    lazy var newslineModule = NewslineModuleBuilder.build(moduleOutput: self)

    private var moduleInput: NewslineModuleInput { self.newslineModule.input }

    // MARK: - Coordinator Protocol

    var nextCoordinator: CoordinatorProtocol?
    private(set) var resultClosures: FlowResultClosuresHolder = .empty
    var presentationType: CoordinatorPresentationType {
        return .custom
    }

    // MARK: - Flow

    func start() { }

    func finish(animated: Bool,
                result: CoordinatorFlowResult,
                resultClosures: FlowResultClosuresHolder) { }
}

// MARK: - NewslineModuleOutput

extension NewslineCoordinator: NewslineModuleOutput {
    func needOpenAlert(title: String) {
        self.startSystemAlerCoordinator(alertController: UIAlertController.alert(with: title,
                                                                                 message: nil,
                                                                                 onAction: { [weak self] in
            self?.resultClosures.onFlowDidFinish(.success)
        }),
                                        sourceViewController: self.newslineModule.viewController,
                                        resultClosures: .empty)
    }

    func needOpenDetailedNewsScreen(newsDeployedModel: NewsDeployedViewModel) {
        self.startDetailedNewsCoordinator(model: newsDeployedModel,
                                          sourceViewController: self.newslineModule.viewController,
                                          resultClosures: .init(onFlowWillFinish: { result in
            self.moduleInput.updateUploadedData()
            self.resultClosures.onFlowWillFinish?(result)
        },
                                                                onFlowDidFinish: { result in
            self.resultClosures.onFlowDidFinish(result)
        }))
    }

    func needOpenSettings() {
        self.startSettingsCoordinator(sourceViewController: self.newslineModule.viewController)
    }
}
