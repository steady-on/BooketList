//
//  BaseCollectionViewCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/01.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHiararchy()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHiararchy() {}
    func setConstraints() {}
}
