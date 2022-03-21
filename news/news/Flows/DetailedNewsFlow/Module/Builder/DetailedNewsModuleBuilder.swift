//
//  DetailedNewsModuleBuilder.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import UIKit

final class DetailedNewsModuleBuilder {

    public static func build(moduleOutput: DetailedNewsModuleOutput, model: NewsDeployedViewModel) -> UIViewController {
        let presenter = DetailedNewsPresenter(moduleOutput: moduleOutput, model: model)
        let viewController = DetailedNewsViewController(output: presenter)
        presenter.viewInput = viewController
        return viewController
    }

}
