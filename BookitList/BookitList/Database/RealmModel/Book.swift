//
//  Book.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class Book: Object {
    @Persisted(primaryKey: true) var _id = ObjectId()
    @Persisted(indexed: true) var itemID: Int
    @Persisted var isbn: String?
    @Persisted var isbn13: String?
    @Persisted var title: String
    @Persisted var originalTitle: String?
    @Persisted var overview: String?
    @Persisted var coverPath: String?
    @Persisted var totalPage: Int?
    @Persisted var publishedAt: Date?
    @Persisted var publisher: String?
    @Persisted var width: Int?
    @Persisted var height: Int?
    @Persisted var depth: Int?
    @Persisted var isOutOfPrint: Bool?
    @Persisted var statusOfReading: StatusOfReading
    @Persisted var registeredAt: Date
    
    @Persisted var authors: List<Author>
    @Persisted var readingHistories: List<ReadingHistory>
    @Persisted var notes: List<Note>
    @Persisted var purchasedHistories: List<PurchaseHistory>
    @Persisted var checkoutHistories: List<CheckoutHistory>
    @Persisted var series: List<Series>
    @Persisted var tags: List<Tag>
}
