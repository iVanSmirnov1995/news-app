//
//  DetailedNewsViewInterface.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

protocol DetailedNewsViewInput: AnyObject {

    /// Установить модель для `view`
    func setupViewModel(model: NewsDeployedViewModel)
}

protocol DetailedNewsViewOutput: ViewOutput {
    /// Вью убирается.
    func viewControllerIsRemoving()
}
