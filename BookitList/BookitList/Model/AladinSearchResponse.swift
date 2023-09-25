//
//  AladinSearchResponse.swift
//  BookitList
//
//  Created by Roen White on 2023/09/25.
//

import Foundation

struct AladinSearchResponse: Decodable {
    let totalResults, startIndex: Int
    let item: [Item]
}

struct Item: Decodable {
    let itemID: Int
    let isbn13: String
    let title, author, description: String
    let pubDate, publisher: String
    let cover: String
    let adult: Bool

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case isbn13, title, author, description, pubDate, publisher, cover, adult
    }
}
