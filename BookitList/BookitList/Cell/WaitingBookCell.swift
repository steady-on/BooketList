//
//  WaitingBookCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/20.
//

import UIKit

final class WaitingBookCell: BaseCollectionViewCell {
    var book: Book! {
        didSet {
            titleLabel.text = book.title
            setConstraints(for: book.size)
        }
    }
    
    private let backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.borderColor = UIColor.reverseBackground.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 7
        view.directionalLayoutMargins = .init(top: 8, leading: 4, bottom: 4, trailing: 4)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.transform = CGAffineTransform(rotationAngle: .pi / 2)
        return label
    }()
    
    override func configureHiararchy() {
        addSubview(backdropView)
        backdropView.addSubview(titleLabel)
    }
    
    private func setConstraints(for size: Size?) {
        let minimumWidth = titleLabel.font.lineHeight + backdropView.layoutMargins.left + backdropView.layoutMargins.right
        let maximumHeight = bounds.height
        let standardHeight = maximumHeight * 0.8
        
        let width = size?.depth ?? minimumWidth
        let height = size?.height ?? standardHeight
        let heightRatio = standardHeight / height
        
        let cellWidth = width < minimumWidth ? minimumWidth : width
        let cellHeight = maximumHeight * heightRatio
        
        backdropView.snp.makeConstraints { make in
            make.width.equalTo(cellWidth)
            make.height.equalTo(cellHeight)
            make.top.greaterThanOrEqualToSuperview()
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(backdropView.layoutMarginsGuide)
            make.height.equalTo(backdropView.layoutMarginsGuide.snp.width)
            make.width.equalTo(backdropView.layoutMarginsGuide.snp.height)
        }
    }
    
    // TODO: 버전 대응
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        backdropView.layer.borderColor = UIColor.reverseBackground.cgColor
    }
}
