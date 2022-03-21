//
//  SystemAlertControllerCoordinator.swift
//  News
//
//  Created by Ivan Smirnov on 28.03.2022.
//

import Foundation
import UIKit

/// Координатор, который показывает системный алерт.
final class SystemAlertCoordinator: CoordinatorProtocol {

    // MARK: - Coordinator Protocol

    var nextCoordinator: CoordinatorProtocol?
    private(set) var resultClosures: FlowResultClosuresHolder
    var presentationType: CoordinatorPresentationType {
        return .custom
    }

    // MARK: - Private Properties

    private weak var sourceViewController: UIViewController?
    private let alertController: UIAlertController

    init(alertController: UIAlertController,
         sourceViewController: UIViewController,
         resultClosures: FlowResultClosuresHolder) {
        self.sourceViewController = sourceViewController
        self.alertController = alertController
        self.resultClosures = resultClosures
    }

    func start() {
        self.sourceViewController?.present(self.alertController, animated: true)
    }

    func finish(animated: Bool, result: CoordinatorFlowResult, resultClosures: FlowResultClosuresHolder) {
        resultClosures.onFlowWillFinish?(result)
        self.alertController.dismiss(animated: true, completion: {
            resultClosures.onFlowDidFinish(result)
        })
    }
}

extension CoordinatorProtocol {

    func startSystemAlerCoordinator(alertController: UIAlertController,
                                    sourceViewController: UIViewController,
                                    resultClosures: FlowResultClosuresHolder = .empty) {
        guard self.nextCoordinator == nil else { return }
        self.nextCoordinator = SystemAlertCoordinator(alertController: alertController,
                                                      sourceViewController: sourceViewController,
                                                      resultClosures: self.mixInCoordinatorRelease(resultClosures))
        self.nextCoordinator?.start()
    }

}
