//
//  WaitingBookCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/20.
//

import UIKit

class WaitingBookCell: BaseCollectionViewCell {
    var bookTitle: String! {
        didSet { titleLabel.text = bookTitle }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.transform = CGAffineTransform(rotationAngle: .pi / 2)
        return label
    }()
    
    override func configureHiararchy() {
        directionalLayoutMargins = .init(top: 8, leading: 4, bottom: 4, trailing: 4)
        backgroundColor = .systemBackground
        configureBorder()
        
        addSubview(titleLabel)
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(layoutMarginsGuide)
            make.height.equalTo(layoutMarginsGuide.snp.width)
            make.width.equalTo(layoutMarginsGuide.snp.height)
        }
    }
    
    private func configureBorder() {
        layer.borderColor = UIColor.reverseBackground.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 7
    }
    
    // TODO: 버전 대응
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.borderColor = UIColor.reverseBackground.cgColor
    }
}
