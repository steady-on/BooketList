//
//  CollectionLayoutStyle.swift
//  BookitList
//
//  Created by Roen White on 2023/11/09.
//

import Foundation

enum CollectionLayoutStyle {
    case grid
    case shelf
    case list
    
    var nextLayout: CollectionLayoutStyle {
        switch self {
        case .grid: return .shelf
        case .shelf: return .list
        case .list: return .grid
        }
    }
    
    var nextLayoutIconName: String {
        switch self {
        case .grid: return "books.vertical.fill"
        case .shelf: return "list.bullet"
        case .list: return "square.grid.2x2.fill"
        }
    }
}
