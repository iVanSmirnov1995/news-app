//
//  NewslineModuleBuilder.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import UIKit

typealias NewslineModule = (input: NewslineModuleInput, viewController: UINavigationController)

final class NewslineModuleBuilder {

    public static func build(moduleOutput: NewslineModuleOutput) -> NewslineModule {
        let interactor = NewslineInteractor()
        let presenter = NewslinePresenter(interactor: interactor,
                                          moduleOutput: moduleOutput)
        let viewController = NewslineViewController(output: presenter)
        presenter.viewInput = viewController
        let navigationController = InteractionNavigationController(rootViewController: viewController)
        return (presenter, navigationController)
    }

}
