//
//  SourceForRealm.swift
//  News
//
//  Created by Ivan Smirnov on 27.03.2022.
//

import Foundation
import RealmSwift

/// Описывает модель данных источников для БД
class SourceForRealm: Object {
    /// `url` источника
    @objc dynamic var urlSrting = ""
}
