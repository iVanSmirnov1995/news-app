//
//  CoordinatorProtocol.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

/// Описывает координатор и представляет интерфейс для взаимодействия между разными координаторами.
protocol CoordinatorProtocol: AnyObject {

    /// Структура с замыканиями, которые будут выполнены при завершении флоу данного координатора.
    var resultClosures: FlowResultClosuresHolder { get }

    /// Способ, которым будет показан данный координатор.
    var presentationType: CoordinatorPresentationType { get }

    /// Следующий координатор.
    var nextCoordinator: CoordinatorProtocol? { get set }

    /// Выполняет старт показа флоу координатора.
    func start()

    /// Выполняет завершение флоу координатора.
    ///
    /// - Parameters:
    ///   - animated: true - с анимацией, false - без анимации.
    ///   - result: Результат завершения флоу.
    ///   - resultClosures: Структура с замыканиями, которые будут выполнены при завершении флоу.
    func finish(animated: Bool, result: CoordinatorFlowResult, resultClosures: FlowResultClosuresHolder)
}

extension CoordinatorProtocol {
    /// Создает копию переданной структуры с замыканиями завершения флоу, при этом добавляет обнуление координатора.
    ///
    /// - Parameter resultClosures: Структура, которую необходимо модифицировать.
    func mixInCoordinatorRelease(_ resultClosures: FlowResultClosuresHolder) -> FlowResultClosuresHolder {
        return resultClosures.before(.didFinish) { [weak self] in
            self?.nextCoordinator = nil
        }
    }
}
