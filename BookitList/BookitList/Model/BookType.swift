//
//  BookType.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

enum BookType: Int, PersistableEnum {
    case paper
    case ebook
    case audio
}
