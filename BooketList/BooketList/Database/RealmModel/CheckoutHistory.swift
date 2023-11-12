//
//  CheckoutHistory.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import Foundation
import RealmSwift

final class CheckoutHistory: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var type: BookType
    @Persisted var checkedoutAt: Date?
    @Persisted var returnedAt: Date?
    @Persisted var memo: String?
    @Persisted var library: String?
    
    @Persisted(originProperty: "checkoutHistories") var book: LinkingObjects<Book>
}
