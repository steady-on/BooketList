//
//  RealmError.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import Foundation

enum RealmError: Error, CustomDebugStringConvertible {
    case notInitialized
    case failToCreateItem
    case failToUpdateItem
    case failToDelete
    case failToQuery
    
    var debugDescription: String {
        switch self {
        case .notInitialized:
            return "데이터베이스를 초기화에 문제가 발생했습니다. 다시 시도해 주세요."
        case .failToCreateItem:
            return "데이터를 추가하는 도중 문제가 발생했습니다. 다시 시도해 주세요."
        case .failToUpdateItem:
            return "데이터를 업데이트 하는 도중 문제가 발생했습니다. 다시 시도해 주세요."
        case .failToDelete:
            return "데이터를 삭제하는 도중 문제가 발생했습니다. 다시 시도해 주세요."
        case .failToQuery:
            return "해당하는 데이터를 발견하지 못했습니다."
        }
    }
}
