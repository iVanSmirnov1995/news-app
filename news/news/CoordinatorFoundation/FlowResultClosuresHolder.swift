//
//  FlowResultClosuresHolder.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation
import UIKit

/// Структура, содержащая в себе замыкания, которые будут выполнены при завершении флоу.
struct FlowResultClosuresHolder {

    /// Тип замыкания завершения флоу.
    typealias FlowFinishClosure = (CoordinatorFlowResult) -> Void

    enum ClousureType {
        case willFinish
        case didFinish
    }

    /// Вызывается перед завершением флоу.
    let onFlowWillFinish: FlowFinishClosure?

    /// Вызывается после завершения влоу. Чаще всего сразу после скрытия контроллера с экрана.
    let onFlowDidFinish: FlowFinishClosure

    init(onFlowWillFinish: FlowFinishClosure? = nil, onFlowDidFinish: @escaping FlowFinishClosure) {
        self.onFlowWillFinish = onFlowWillFinish
        self.onFlowDidFinish = onFlowDidFinish
    }

}

extension FlowResultClosuresHolder {

    /// Создает структуру `FlowResultClosuresHolder` с пустыми замыканиями.
    static var empty: FlowResultClosuresHolder {
        return FlowResultClosuresHolder { _ in }
    }

    /// Создает новую структуру FlowResultClosuresHolder. Модифицирует замыкание с заданным типом, при этом добавляет
    /// переданное замыкание перед оригинальным.
    ///
    /// - Parameters:
    ///   - closureType: Тип замыкания, которое необходимо модифицировать.
    ///   - closure: Замыкание, которое будет выполнено.
    func before(_ closureType: FlowResultClosuresHolder.ClousureType,
                closure: @escaping VoidClosure) -> FlowResultClosuresHolder {
        switch closureType {
        case .didFinish:
            let onFlowDidFinish = self.onFlowDidFinish
            return FlowResultClosuresHolder(onFlowWillFinish: self.onFlowWillFinish) { result in
                closure()
                onFlowDidFinish(result)
            }
        case .willFinish:
            let onFlowWillFinish = self.onFlowWillFinish
            return FlowResultClosuresHolder(onFlowWillFinish: { result in
                closure()
                onFlowWillFinish?(result)
            }, onFlowDidFinish: self.onFlowDidFinish)
        }
    }
}
