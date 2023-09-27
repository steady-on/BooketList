//
//  Note.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class Note: Object {
    @Persisted(primaryKey: true) var _id = ObjectId()
    @Persisted var createdAt: Date
    @Persisted var type: NoteType
    @Persisted var page: Int?
    @Persisted var content: String?
    
    @Persisted var imagePaths: List<String>
    @Persisted var comments: List<Comment>
    
    @Persisted var readingHistory: ReadingHistory?
    @Persisted(originProperty: "notes") var book: LinkingObjects<Book>
    
    enum NoteType: Int, PersistableEnum {
        case quote
        case summary
        case thinking
        case question
        case report
        case memory
    }
}
