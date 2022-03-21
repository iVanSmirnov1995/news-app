//
//  NavigationInteractionMethod.swift
//  News
//
//  Created by Ivan Smirnov on 26.03.2022.
//

import Foundation

/// Способ закрытия экрана если он находится в стэке InteractionDependableNavigationController
public enum NavigationInteractionMethod {

    /// Нажатие на кнопку "назад"
    case backButtonTap

    /// Интерактивный жест от левого края
    case popGesture

}
