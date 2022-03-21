//
//  DetailedNewsCoordinator.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

/// Координатор детального отображения новости
final class DetailedNewsCoordinator: CoordinatorProtocol {

    // MARK: - Coordinator Protocol

    var nextCoordinator: CoordinatorProtocol?
    var presentationType: CoordinatorPresentationType {
        return .push(source: self.sourceViewController, initial: self.initialViewController)
    }

    let resultClosures: FlowResultClosuresHolder
    private let sourceViewController: UINavigationController

    // MARK: - Private properties

    private lazy var initialViewController = DetailedNewsModuleBuilder.build(moduleOutput: self, model: self.model)
    private let model: NewsDeployedViewModel

    // MARK: - Init

    init(model: NewsDeployedViewModel,
         sourceViewController: UINavigationController,
         resultClosures: FlowResultClosuresHolder) {
        self.model = model
        self.sourceViewController = sourceViewController
        self.resultClosures = resultClosures
    }
}

// MARK: - DetailedNewsModuleOutput

extension DetailedNewsCoordinator: DetailedNewsModuleOutput {
    func userDidFinishFlow() {
        self.finish(animated: true, result: .userCancelled, resultClosures: self.resultClosures)
    }
}

extension CoordinatorProtocol {

    func startDetailedNewsCoordinator(model: NewsDeployedViewModel,
                                      sourceViewController: UINavigationController,
                                      resultClosures: FlowResultClosuresHolder = .empty) {
        self.nextCoordinator = DetailedNewsCoordinator(model: model,
                                                       sourceViewController: sourceViewController,
                                                       resultClosures: self.mixInCoordinatorRelease(resultClosures))
        self.nextCoordinator?.start()
    }
}
