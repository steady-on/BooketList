//
//  PurchaseHistory.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class PurchaseHistory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var type: BookType
    @Persisted var puchasedAt: Date?
    @Persisted var memo: String?
    @Persisted var store: String?
    
    @Persisted(originProperty: "purchasedHistories") var book: LinkingObjects<Book>
}
