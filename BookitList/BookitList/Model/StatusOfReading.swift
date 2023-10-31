//
//  StatusOfReading.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import UIKit
import RealmSwift

enum StatusOfReading: Int, PersistableEnum {
    case notYet
    case reading
    case finished
    case pause
    case stop
}

extension StatusOfReading: Titled {
    var title: String {
        switch self {
        case .notYet: return "아직 안 읽음"
        case .reading: return "지금 읽는 중"
        case .finished: return "다 읽음"
        case .pause: return "잠시 읽기 중단 중"
        case .stop: return "읽기 중단"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .notYet: return "book.closed"
        case .reading: return "book"
        case .finished: return "book.closed.fill"
        case .pause: return "pause"
        case .stop: return "stop.fill"
        }
    }
}

extension StatusOfReading: Coloring {
    var color: UIColor {
        switch self {
        case .notYet: return .blGray
        case .reading: return .blBlue
        case .finished: return .blGreen
        case .pause: return .blYellow
        case .stop: return .blRed
        }
    }
}
