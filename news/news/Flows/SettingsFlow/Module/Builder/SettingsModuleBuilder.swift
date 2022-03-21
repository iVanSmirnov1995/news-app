//
//  SettingsModuleBuilder.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import UIKit

final class SettingsModuleBuilder {

    public static func build(moduleOutput: SettingsModuleOutput) -> UIViewController {
        let presenter = SettingsPresenter(moduleOutput: moduleOutput)
        let viewController = SettingsViewController(output: presenter)
        presenter.viewInput = viewController
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }

}
