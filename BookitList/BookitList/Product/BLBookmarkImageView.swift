//
//  BLBookmarkImageView.swift
//  BookitList
//
//  Created by Roen White on 2023/10/01.
//

import UIKit

class BLBookmarkImageView: UIImageView {
    init() {
        super.init(frame: .zero)
        configureHiararchy()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHiararchy() {
        let symbolConfig = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "bookmark.fill", withConfiguration: symbolConfig)
        
        self.image = image
        tintColor = .accent
        contentMode = .scaleToFill
    }
}
