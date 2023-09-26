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
    @Persisted var content: String?
    @Persisted var imagePaths: List<String>
    
    @Persisted var readingRecord: ReadingRecord?
    
    @Persisted var comments: List<Comment>
    
    enum NoteType: Int, PersistableEnum {
        case quote
        case summary
        case thinking
        case question
        case report
    }
}
