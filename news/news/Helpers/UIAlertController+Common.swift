//
//  UIAlertController+Common.swift
//  News
//
//  Created by Ivan Smirnov on 28.03.2022.
//

import Foundation
import UIKit

extension UIAlertController {

    static func alert(with title: String?, message: String? = nil, onAction: VoidClosure? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: { _ in
            onAction?()
        }))
        return alertController
    }
}
