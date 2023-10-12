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
    let isbn, isbn13: String?
    var title, author: String
    var description, fullDescription, cover: String?
    let pubDate, publisher: String
    let stockStatus: String
    let subInfo: SubInfo

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case isbn, isbn13, title, author, description, pubDate, publisher, cover, stockStatus, fullDescription, subInfo
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.itemID = try container.decode(Int.self, forKey: .itemID)
        self.title = try container.decode(String.self, forKey: .title)
        self.author = try container.decode(String.self, forKey: .author)
        
        let isbn = try container.decode(String.self, forKey: .isbn)
        self.isbn = isbn.isEmpty ? nil : isbn
        
        let isbn13 = try container.decode(String.self, forKey: .isbn13)
        self.isbn13 = isbn13.isEmpty ? nil : isbn13
                
        let description = try container.decode(String.self, forKey: .description)
        self.description = description.isEmpty ? nil : description

        let fullDescription = try container.decode(String.self, forKey: .fullDescription)
        self.fullDescription = fullDescription.isEmpty ? nil : fullDescription.replacingOccurrences(of: "<br>", with: "")

        let cover = try container.decode(String.self, forKey: .cover)
        self.cover = cover.isEmpty ? nil : cover
        
        self.pubDate = try container.decode(String.self, forKey: .pubDate)
        self.publisher = try container.decode(String.self, forKey: .publisher)
        self.stockStatus = try container.decode(String.self, forKey: .stockStatus)
        self.subInfo = try container.decode(SubInfo.self, forKey: .subInfo)
    }
}

struct SubInfo: Decodable {
    let itemPage: Int
    let originalTitle: String?
    let packing: Packing
    let previewImgList: [String]?
    let authors: [Artist]
    
    enum CodingKeys: CodingKey {
        case itemPage, originalTitle, packing, previewImgList, authors
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.itemPage = try container.decode(Int.self, forKey: .itemPage)
        
        
        let originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.originalTitle = originalTitle.isEmpty ? nil : originalTitle
        
        self.packing = try container.decode(Packing.self, forKey: .packing)
        
        let previewImgList = try container.decode([String].self, forKey: .previewImgList)
        self.previewImgList = previewImgList.isEmpty ? nil : previewImgList
        self.authors = try container.decode([Artist].self, forKey: .authors)
    }
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
