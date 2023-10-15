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
    
    convenience init(from item: ItemDetail, artists: [Artist]) {
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
        
        let authors = List<Author>()
        artists.forEach { artist in
            guard artist.willRegister else { return }
            let author = Author(authorID: artist.authorId, name: artist.authorName)
            authors.append(author)
        }
        self.authors = authors
        
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
    @Persisted var width: Int?
    @Persisted var height: Int?
    @Persisted var depth: Int?
    
    convenience init(width: Int?, height: Int?, depth: Int?) {
        self.init()
        self.width = width
        self.height = height
        self.depth = depth
    }
}
