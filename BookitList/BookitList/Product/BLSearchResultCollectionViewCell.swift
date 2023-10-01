//
//  BLSearchResultCollectionViewCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/01.
//

import UIKit

final class BLSearchResultCollectionViewCell: BaseCollectionViewCell {
    
    private let backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let infoTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .callout)
        textView.textColor = .secondaryLabel
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        return textView
    }()
    
    private let bookmarkImageView  = BLBookmarkImageView()
    
    override func configureHiararchy() {
        contentView.backgroundColor = .background
        contentView.addSubview(backdropView)
        
        let components = [coverImageView, bookmarkImageView, infoTextStackView]
        components.forEach { component in backdropView.addSubview(component) }
        
        let stackComponents = [titleLabel, authorLabel, overviewTextView]
        stackComponents.forEach { component in infoTextStackView.addSubview(component) }
    }
    
    override func setConstraints() {
        backdropView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(coverImageView.snp.width).multipliedBy(2/3)
        }
        
        bookmarkImageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(coverImageView).inset(8)
            make.width.equalTo(coverImageView).multipliedBy(0.2)
            make.height.equalTo(bookmarkImageView.snp.width).multipliedBy(1.2)
        }
        
        infoTextStackView.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(backdropView.layoutMarginsGuide)
            make.leading.equalTo(coverImageView.snp.trailing).offset(12)
        }
    }
}
