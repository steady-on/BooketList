//
//  NoteType.swift
//  BookitList
//
//  Created by Roen White on 2023/10/26.
//

import UIKit
import RealmSwift

enum NoteType: Int, PersistableEnum {
    case quote
    case summary
    case thinking
    case question
    case report
    case memory
}

extension NoteType: Titled {
    var title: String {
        switch self {
        case .quote: return "책속의 한줄"
        case .summary: return "내용 요약"
        case .thinking: return "떠오른 생각"
        case .question: return "의문점"
        case .report: return "감상"
        case .memory: return "추억"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .quote: return "bookmark.fill"
        case .summary: return "doc.append"
        case .thinking: return "ellipsis.bubble"
        case .question: return "questionmark.circle"
        case .report: return "doc.text"
        case .memory: return "calendar"
        }
    }
}

extension NoteType: Coloring {
    var color: UIColor {
        switch self {
        case .quote: return .blBlue
        case .summary: return .blGray
        case .thinking: return .blGreen
        case .question: return .blRed
        case .report: return .blYellow
        case .memory: return .blBrown
        }
    }
}
