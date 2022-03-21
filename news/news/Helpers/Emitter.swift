//
//  Emitter.swift
//  News
//
//  Created by Ivan Smirnov on 26.03.2022.
//

import Foundation

/// Алиас типа возвращаемого значения кложуры эмиттера.
public typealias ShouldContinueReceiveNotifications = Bool

/// Тип реакции текущего эмиттера для указанного `T`
///
/// Необходимо вернуть false, если больше нет нужды вызывать данную реакцию, true - иначе
public typealias ReactionClosure<T> = (T) -> ShouldContinueReceiveNotifications

/// Класс, реализующий механизм нотификаций через замыкания
public class Emitter<T> {

    var reactions: [ReactionClosure<T>] = []

    public init() {}

    /// Добавить реакцию на событие
    ///
    /// - Parameter reaction: Замыкание, которое будет вызвано, при появлении события
    public func addReaction(_ reaction: @escaping ReactionClosure<T>) {
        self.reactions.append(reaction)
    }

    /// Вызвать реакции на событие
    ///
    /// - Parameter object: Параметры события
    public func invoke(_ object: T) {
        self.reactions = self.reactions.filter {
            $0(object)
        }
    }
}
