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
    @Persisted var existCover: ExistCover?
    @Persisted var totalPage: Int?
    @Persisted var publishedAt: String?
    @Persisted var publisher: String?
    @Persisted var size: Size?
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
    
    convenience init(from item: ItemDetail, artists: [Author]) {
        self.init()
        
        self.itemID = item.itemID
        self.isbn = item.isbn
        self.isbn13 = item.isbn13
        self.title = item.title
        self.originalTitle = item.subInfo.originalTitle
        self.overview = item.description ?? item.fullDescription
        self.existCover = ExistCover()
        self.totalPage = item.subInfo.itemPage
        self.publishedAt = item.pubDate
        self.publisher = item.publisher
        
        self.size = Size(width: item.subInfo.packing.sizeWidth, 
                         height: item.subInfo.packing.sizeHeight,
                         depth: item.subInfo.packing.sizeDepth)
        
        self.isOutOfPrint = item.stockStatus == "절판"
        
        self.statusOfReading = .notYet
        self.registeredAt = Date.now
        
        self.authors = List<Author>()
        artists.forEach { author in
            self.authors.append(author)
        }
        
        self.readingHistories = List<ReadingHistory>()
        self.notes = List<Note>()
        self.purchasedHistories = List<PurchaseHistory>()
        self.checkoutHistories = List<CheckoutHistory>()
        self.series = List<Series>()
        self.tags = List<Tag>()
    }
}

final class ExistCover: EmbeddedObject {
    @Persisted var thumbnail: Bool
    @Persisted var full: Bool
    
    convenience init(thumbnail: Bool = false, full: Bool = false) {
        self.init()
        self.thumbnail = thumbnail
        self.full = full
    }
}

final class Size: EmbeddedObject {
    @Persisted var width: Double = 0
    @Persisted var height: Double = 0
    @Persisted var depth: Double = 0
    
    convenience init(width: Int?, height: Int?, depth: Int?) {
        self.init()
        self.width = Double(width ?? 0)
        self.height = Double(height ?? 0)
        self.depth = Double(depth ?? 0)
    }
}
