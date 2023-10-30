//
//  Date+.swift
//  BookitList
//
//  Created by Roen White on 2023/10/27.
//

import Foundation

extension Date {
    var basicString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .long
        return formatter.string(from: self)
    }
}
