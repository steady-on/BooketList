//
//  Book.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class Book: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(indexed: true) var itemID: Int
    @Persisted var isbn: String?
    @Persisted var isbn13: String?
    @Persisted var title: String
    @Persisted var originalTitle: String?
    @Persisted var overview: String?
    @Persisted var coverImageSize: ImageSize?
    @Persisted var totalPage: Int?
    @Persisted var publishedAt: String?
    @Persisted var publisher: String?
    @Persisted var actualSize: ActualSize?
    @Persisted var isOutOfPrint: Bool?
    @Persisted var statusOfReading: StatusOfReading
    @Persisted var registeredAt: Date
    @Persisted var latestUpdatedAt: Date
    
    @Persisted var authors: List<Author>
    @Persisted var readingHistories: List<ReadingHistory>
    @Persisted var notes: List<Note>
    @Persisted var purchasedHistories: List<PurchaseHistory>
    @Persisted var checkoutHistories: List<CheckoutHistory>
    @Persisted var series: List<Series>
    @Persisted var tags: List<Tag>
    
    convenience init(from item: ItemDetail) {
        self.init()
        
        self.itemID = item.itemID
        self.isbn = item.isbn
        self.isbn13 = item.isbn13
        self.title = item.title
        self.originalTitle = item.subInfo.originalTitle
        self.overview = item.description ?? item.fullDescription
        self.totalPage = item.subInfo.itemPage
        self.publishedAt = item.pubDate
        self.publisher = item.publisher
        
        self.actualSize = ActualSize(from: item.subInfo.packing)
        
        self.isOutOfPrint = item.stockStatus == "절판"
        
        self.statusOfReading = .notYet
        self.registeredAt = Date.now
        self.latestUpdatedAt = Date.now
        
        self.readingHistories = List<ReadingHistory>()
        self.notes = List<Note>()
        self.purchasedHistories = List<PurchaseHistory>()
        self.checkoutHistories = List<CheckoutHistory>()
        self.series = List<Series>()
        self.tags = List<Tag>()
    }
}

final class ImageSize: EmbeddedObject {
    @Persisted var width: Double
    @Persisted var height: Double
    
    convenience init(from size: CGSize) {
        self.init()
        self.width = size.width
        self.height = size.height
    }
}

final class ActualSize: EmbeddedObject {
    @Persisted var width: Double
    @Persisted var height: Double
    @Persisted var depth: Double
    
    convenience init(from packing: Packing) {
        self.init()
        self.width = Double(packing.sizeWidth)
        self.height = Double(packing.sizeHeight)
        self.depth = Double(packing.sizeDepth)
    }
}
