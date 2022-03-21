//
//  CoordinatorHelpers.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

/// Список результатов работы флоу.
public enum CoordinatorFlowResult {
    /// Флоу завершился с успешным результатом. Успешность - в том числе с точки зрения бизнес логики.
    case success

    /// Флоу отменен пользователем.
    case userCancelled

    /// Произошла ошибка во время работы флоу.
    case failure(Error?)
}

public enum CoordinatorPresentationType {
    /// Координатор будет запушен.
    case push(source: UINavigationController?, initial: UIViewController)

    /// Координатор будет запрезенчен.
    case present(source: UIViewController?, initial: UIViewController)

    /// Не определено.
    case custom
}
