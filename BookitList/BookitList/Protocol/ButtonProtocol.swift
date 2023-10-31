//
//  ButtonProtocol.swift
//  BookitList
//
//  Created by Roen White on 2023/10/10.
//

import UIKit

protocol Titled {
    var title: String { get }
    var iconImageName: String { get }
}

protocol Coloring {
    var color: UIColor { get }
}

typealias SelectableButton = Titled & CaseIterable & RawRepresentable<Int>

typealias ShowingMenuButton = Titled & Coloring & CaseIterable
