//
//  Cautionable.swift
//  BookitList
//
//  Created by Roen White on 2023/10/13.
//

import Foundation

protocol Cautionable: AnyObject {
    var caution: Observable<Caution> { get }
}
