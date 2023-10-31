//
//  NoteType.swift
//  BookitList
//
//  Created by Roen White on 2023/10/26.
//

import Foundation
import RealmSwift

enum NoteType: Int, PersistableEnum {
    case quote
    case summary
    case thinking
    case question
    case report
    case memory
    
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
}
