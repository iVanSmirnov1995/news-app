//
//  SettingsCoordinator.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

/// Координатор настроек
final class SettingsCoordinator: CoordinatorProtocol {

    // MARK: - Coordinator Protocol

    var nextCoordinator: CoordinatorProtocol?
    var presentationType: CoordinatorPresentationType {
        return .present(source: self.sourceViewController, initial: self.initialViewController)
    }

    private let sourceViewController: UIViewController
    let resultClosures: FlowResultClosuresHolder

    private lazy var initialViewController = SettingsModuleBuilder.build(moduleOutput: self)

    // MARK: - Init

    init(sourceViewController: UIViewController,
         resultClosures: FlowResultClosuresHolder) {
        self.sourceViewController = sourceViewController
        self.resultClosures = resultClosures
    }
}

// MARK: - SettingsModuleOutput

extension SettingsCoordinator: SettingsModuleOutput {
    func userDidFinishFlow() {
        self.finish(animated: true, result: .userCancelled, resultClosures: self.resultClosures)
    }
}

extension CoordinatorProtocol {

    func startSettingsCoordinator(sourceViewController: UIViewController,
                                  resultClosures: FlowResultClosuresHolder = .empty) {
        self.nextCoordinator = SettingsCoordinator(sourceViewController: sourceViewController,
                                                   resultClosures: self.mixInCoordinatorRelease(resultClosures))
        self.nextCoordinator?.start()
    }
}
