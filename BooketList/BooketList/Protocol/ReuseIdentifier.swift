//
//  CellReusable.swift
//  BookitList
//
//  Created by Roen White on 2023/10/27.
//

import Foundation

protocol ReuseIdentifier {
    static var identifier: String { get }
}

extension ReuseIdentifier {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
