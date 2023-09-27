//
//  Series.swift
//  BookitList
//
//  Created by Roen White on 2023/09/27.
//

import UIKit
import RealmSwift

final class Series: Object {
    @Persisted(primaryKey: true) var _id = ObjectId()
    @Persisted var title: String
    @Persisted var definition: String?
    @Persisted var createdAt: Date
}
