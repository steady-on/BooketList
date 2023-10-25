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
    case pause
    case stop
    
    var label: String {
        switch self {
        case .notYet: return "아직 안 읽음"
        case .reading: return "지금 읽는 중"
        case .finished: return "다 읽음"
        case .pause: return "잠시 읽기 중단 중"
        case .stop: return "읽기 중단"
        }
    }
}
