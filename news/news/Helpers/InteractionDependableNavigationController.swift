//
//  InteractionDependableNavigationController.swift
//  News
//
//  Created by Ivan Smirnov on 26.03.2022.
//

import UIKit

public protocol NavigationInteractionDependable: AnyObject {

    /// Метод, который вызывается, когда вью контроллер убирается с экрана
    func viewControllerIsRemovingBy(_ navigationInteractionMethod: NavigationInteractionMethod)

}

public class InteractionNavigationController: UINavigationController {

    // MARK: - Lifecycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    // MARK: - Private methods

    private func detectRemoving(coordinator: UIViewControllerTransitionCoordinator,
                                navigationInteractionMethod: NavigationInteractionMethod) {
        let fromVC = coordinator.viewController(forKey: UITransitionContextViewControllerKey.from)
        if let viewController = fromVC as? NavigationInteractionDependable {
            viewController.viewControllerIsRemovingBy(navigationInteractionMethod)
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension InteractionNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController,
                                     willShow viewController: UIViewController,
                                     animated: Bool) {
        if let coordinator = self.topViewController?.transitionCoordinator {
            if !coordinator.isInteractive {
                if coordinator.isCancelled {
                    return
                }
                self.detectRemoving(coordinator: coordinator, navigationInteractionMethod: .backButtonTap)
                return
            }
            coordinator.notifyWhenInteractionChanges { [weak self] context in
                if context.isCancelled {
                    return
                }
                self?.detectRemoving(coordinator: coordinator, navigationInteractionMethod: .popGesture)
            }
        }
    }
}
