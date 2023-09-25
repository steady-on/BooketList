//
//  AladinLookUpResponse.swift
//  BookitList
//
//  Created by Roen White on 2023/09/25.
//

import Foundation

struct AladinLookUpResponse: Decodable {
    let itemDetail: [ItemDetail]

    enum CodingKeys: String, CodingKey {
        case itemDetail = "item"
    }
}

struct ItemDetail: Decodable {
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
