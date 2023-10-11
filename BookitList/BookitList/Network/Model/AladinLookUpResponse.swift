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
    let isbn, isbn13: String
    let title, author, description: String
    let pubDate, publisher: String
    let cover, stockStatus: String
    let subInfo: SubInfo

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case isbn, isbn13, title, author, description, pubDate, publisher, cover, stockStatus, subInfo
    }
}

struct SubInfo: Decodable {
    let itemPage: Int
    let originalTitle: String
    let packing: Packing
    let previewImgList: [String]
    let authors: [Artist]
}

struct Packing: Decodable {
    let sizeDepth: Int
    let sizeHeight: Int
    let sizeWidth: Int
}

struct Artist: Decodable {
    let authorId: Int
    let authorName: String
    let authorType: String
}
