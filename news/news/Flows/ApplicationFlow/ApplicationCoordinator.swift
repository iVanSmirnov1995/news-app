//
//  ApplicationCoordinator.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

final class ApplicationCoordinator: CoordinatorProtocol {

    // MARK: - Internal properties

    lazy var navBarCoordinator = NewslineCoordinator()

    var rootController: UIViewController { self.navBarCoordinator.newslineModule.viewController }

    // MARK: - Private properties

    private let window: UIWindow

    // MARK: - Init

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Coordinator Protocol

    var nextCoordinator: CoordinatorProtocol?
    private(set) var resultClosures: FlowResultClosuresHolder = .empty
    var presentationType: CoordinatorPresentationType { .custom }

    // MARK: - Flow

    func start() {
        self.nextCoordinator = self.navBarCoordinator
        self.window.rootViewController = self.rootController
        self.window.makeKeyAndVisible()
    }

    func finish(animated: Bool,
                result: CoordinatorFlowResult,
                resultClosures: FlowResultClosuresHolder) { }
}
