//
//  ReadingRecord.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class ReadingHistory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var round: Int
    @Persisted var status: Status
    @Persisted var startedAt: Date
    @Persisted var finishedAt: Date?
    @Persisted var rate: Double?
    @Persisted var presentReadingPage: Int
    
    @Persisted var readingRecords: List<ReadingRecord>
    
    @Persisted(originProperty: "readingHistories") var book: LinkingObjects<Book>
    @Persisted(originProperty: "readingHistory") var note: LinkingObjects<Note>
    
    enum Status: Int, PersistableEnum {
        case reading
        case finished
        case pause
        case stop
    }
}
