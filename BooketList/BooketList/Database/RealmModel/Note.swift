//
//  Note.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class Note: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var createdAt: Date
    @Persisted var type: NoteType
    @Persisted var page: Int?
    @Persisted var content: String
    
    @Persisted var haveImage: Bool
    @Persisted var comments: List<Comment>
    
    @Persisted var readingHistory: ReadingHistory?
    @Persisted(originProperty: "notes") var book: LinkingObjects<Book>
    
    convenience init(type: NoteType, page: Int?, content: String) {
        self.init()
        
        self.createdAt = Date.now
        self.type = type
        self.page = page
        self.content = content
    }
}
