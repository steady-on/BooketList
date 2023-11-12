//
//  AladinSearchResponse.swift
//  BookitList
//
//  Created by Roen White on 2023/09/25.
//

import Foundation
import RealmSwift

struct AladinSearchResponse: Decodable {
    let totalResults, startIndex: Int
    let item: [Item]
}

struct Item: Decodable, Hashable {
    let itemID: Int
    let isbn13: String
    let title, author, description: String
    let pubDate, publisher: String
    let cover: String
    var objectID: ObjectId? = nil

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case isbn13, title, author, description, pubDate, publisher, cover
    }
}
