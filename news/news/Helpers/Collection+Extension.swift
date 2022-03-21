//
//  Collection+Extension.swift
//  News
//
//  Created by Иван Смирнов on 24.03.2022.
//

import Foundation

extension Collection {

    /// Безопасно получить элемент из коллекции по указанному индексу.
    /// Если элемента по указанному индексу не существует, то будет возвращен `nil`.
    public subscript(safe index: Index) -> Element? {
        return (self.startIndex..<self.endIndex) ~= index ? self[index] : nil
    }
}
