//
//  Typealias.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

/// Для замыканий, которые принимают `Void` и отдают `Void`
typealias VoidClosure = () -> Void

/// Для замыканий, которые принимают `generic` тип `T` и отдают `Void`
typealias ItemClosure<T> = (T) -> Void
