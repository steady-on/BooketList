//
//  StatusOfReading.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

enum StatusOfReading: Int, PersistableEnum {
    case notYet
    case reading
    case finished
    case giveUp
}
