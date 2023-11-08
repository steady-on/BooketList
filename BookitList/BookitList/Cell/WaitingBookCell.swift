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
            remakeBackdropViewConstraints(for: book.actualSize)
        }
    }
    
    private let backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
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
    
    override func setConstraints() {
        backdropView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(backdropView.layoutMarginsGuide)
            make.height.equalTo(backdropView.layoutMarginsGuide.snp.width)
            make.width.equalTo(backdropView.layoutMarginsGuide.snp.height)
        }
    }
    
    private func remakeBackdropViewConstraints(for size: ActualSize?) {
        guard let size else { return }
        
        let minimumWidth = titleLabel.font.lineHeight + backdropView.layoutMargins.left + backdropView.layoutMargins.right
        let maximumHeight = bounds.height
        let standardHeight = maximumHeight * 0.8
        
        let width = size.depth
        let height = size.height
        let heightRatio = standardHeight / height
        
        let cellWidth = width < minimumWidth ? minimumWidth : width
        let cellHeight = height == 0 ? standardHeight : maximumHeight * heightRatio
        
        backdropView.snp.remakeConstraints { make in
            make.width.equalTo(cellWidth)
            make.height.equalTo(cellHeight)
            make.top.greaterThanOrEqualToSuperview()
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // TODO: 버전 대응
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        backdropView.layer.borderColor = UIColor.reverseBackground.cgColor
    }
}
