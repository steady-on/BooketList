//
//  Author.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class Author: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted(indexed: true) var authorID: Int?
    @Persisted var name: String
    @Persisted var isTracking: Bool
    @Persisted var typeDescriptions: Map<String, String>
    
    @Persisted(originProperty: "authors") var books: LinkingObjects<Book>
    
    convenience init(from artist: Artist, for bookId: String) {
        self.init()
        
        self.authorID = artist.authorId
        self.name = artist.authorName
        self.isTracking = artist.isTracking
        self.typeDescriptions.setValue(artist.authorTypeDesc, forKey: bookId)
    }
}
