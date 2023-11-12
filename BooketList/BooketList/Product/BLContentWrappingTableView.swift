//
//  BLContentWrappingTableView.swift
//  BookitList
//
//  Created by Roen White on 2023/10/27.
//

import UIKit

final class BLContentWrappingTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}
