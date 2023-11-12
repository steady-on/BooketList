//
//  Comment.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class Comment: EmbeddedObject {
    @Persisted var id: ObjectId
    @Persisted var createdAt: Date
    @Persisted var content: String
}
