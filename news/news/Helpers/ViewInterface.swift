//
//  ViewInterface.swift
//  News
//
//  Created by Ivan Smirnov on 21.03.2022.
//

import Foundation

/// Описание сущности, которая умеет обрабатывать входящие события представления
protocol ViewOutput {

    /// Представление было загружено.
    func viewDidLoad()

    /// Представление будет показано пользователю.
    func viewWillAppear()

    /// Представление было показано пользователю.
    func viewDidAppear()

    /// Представление будет скрыто от пользователя.
    func viewWillDisappear()

    /// Представление было скрыто от пользователя.
    func viewDidDisappear()

}

extension ViewOutput {

    func viewDidLoad() { }

    func viewWillAppear() { }

    func viewDidAppear() { }

    func viewWillDisappear() { }

    func viewDidDisappear() { }

}
