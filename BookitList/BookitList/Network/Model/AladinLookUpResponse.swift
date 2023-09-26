//
//  AladinLookUpResponse.swift
//  BookitList
//
//  Created by Roen White on 2023/09/25.
//

import Foundation

struct AladinLookUpResponse: Decodable {
    let item: [ItemDetail]
}

struct ItemDetail: Decodable {
    let itemID: Int
    let isbn13: String
    let title, author, description: String
    let pubDate, publisher: String
    let cover: String
    let subInfo: SubInfo

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case isbn13, title, author, description, pubDate, publisher, cover, subInfo
    }
}

struct SubInfo: Decodable {
    let originalTitle: String
    let packing: Packing
}

struct Packing: Decodable {
    let sizeDepth: Int
    let sizeHeight: Int
    let sizeWidth: Int
}
