//
//  ReadingRecord.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class ReadingRecord: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var startedAt: Date?
    @Persisted var recordedAt: Date
    @Persisted var markedPage: Int
}
