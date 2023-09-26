//
//  Comment.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class Comment: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var createdAt: Date
    @Persisted var content: String
}
