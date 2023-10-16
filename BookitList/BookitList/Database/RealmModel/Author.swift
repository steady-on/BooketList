//
//  Author.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class Author: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(indexed: true) var authorID: Int?
    @Persisted var name: String
    
    convenience init(authorID: Int? = nil, name: String) {
        self.init()
        
        self.authorID = authorID
        self.name = name
    }
}
