//
//  SettingsModuleInterface.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

protocol DetailedNewsModuleOutput: AnyObject {
    /// Юзер закончил флоу
    func userDidFinishFlow()
}
