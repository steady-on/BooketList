//
//  ReadingRecord.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class ReadingRecord: EmbeddedObject {
    @Persisted var id: ObjectId
    @Persisted var startedAt: Date?
    @Persisted var recordedAt: Date
    @Persisted var markedPage: Int
}
