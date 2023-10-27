//
//  BLTitleSupplementaryView.swift
//  BookitList
//
//  Created by Roen White on 2023/10/26.
//

import UIKit

final class BLTitleSupplementaryView: BaseCollectionViewCell {
    var title: String! {
        didSet { label.text = title }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    override func configureHiararchy() {
        addSubview(label)
    }
    
    override func setConstraints() {
        label.snp.makeConstraints { make in
            make.edges.equalTo(layoutMarginsGuide)
        }
    }
}
