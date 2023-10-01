//
//  BLBookmarkImageView.swift
//  BookitList
//
//  Created by Roen White on 2023/10/01.
//

import UIKit

class BLBookmarkImageView: UIImageView {
    
    override func draw(_ rect: CGRect) {
        configureHiararchy()
    }
    
    private func configureHiararchy() {
        let symbolConfig = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "bookmark.fill", withConfiguration: symbolConfig)
        
        self.image = image
        tintColor = .highlight
        contentMode = .scaleToFill
    }
}
