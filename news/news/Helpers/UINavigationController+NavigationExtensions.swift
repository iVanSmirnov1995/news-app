//
//  UINavigationController+NavigationExtensions.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

public extension UINavigationController {

    // MARK: - NavigationExtension

    /// Сделать `pop` до вью контроллера, который находится в стеке перед указанным вью контроллером.
    ///
    /// - Parameters:
    ///   - viewController: Вью контроллер.
    ///   Этот и все вью контроллеры, которые находятся после него, будут удалены из стека.
    ///   - animated: `true` - с анимацией, `false` - без.
    func popToPreviousViewController(of viewController: UIViewController, animated: Bool) {
        guard self.viewControllers.count > 1, let index = self.viewControllers.firstIndex(of: viewController) else {
                    return
                }
        let popIndex = max(0, index - 1)
        let toViewController = self.viewControllers[popIndex]
        self.popToViewController(toViewController, animated: animated)
    }
}
