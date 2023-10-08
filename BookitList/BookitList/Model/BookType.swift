//
//  BookType.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

enum BookType: Int, CaseIterable, PersistableEnum {
    case paper
    case ebook
    case audio
    
    var buttonTitle: String {
        switch self {
        case .paper: return "종이책"
        case .ebook: return "전자책"
        case .audio: return "오디오북"
        }
    }
}
