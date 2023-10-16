//
//  BLSearchResultCollectionCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/01.
//

import UIKit
import Kingfisher

final class BLSearchResultCollectionCell: BaseCollectionViewCell {
    
    var item: Item? {
        didSet {
            guard let item else { return }
            
            let url = URL(string: item.cover)
            coverImageView.kf.indicatorType = .activity
            coverImageView.kf.setImage(with: url)
            
            titleLabel.text = item.title
            authorLabel.text = item.author
            overviewTextView.text = item.description
            bookmarkImageView.isHidden = item.isRegistered == false
        }
    }
    
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
        textView.textContainer.maximumNumberOfLines = 3
        textView.isSelectable = false
        return textView
    }()
    
    private let bookmarkImageView  = BLBookmarkImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        coverImageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        overviewTextView.text = nil
    }
    
    override func configureHiararchy() {
        contentView.backgroundColor = .background
        contentView.addSubview(backdropView)
        
        let components = [coverImageView, bookmarkImageView, infoTextStackView]
        components.forEach { component in backdropView.addSubview(component) }
        
        let stackComponents = [titleLabel, authorLabel, overviewTextView]
        stackComponents.forEach { component in infoTextStackView.addArrangedSubview(component) }
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        overviewTextView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    override func setConstraints() {
        backdropView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.layoutMarginsGuide)
        }
        
        coverImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.height.equalToSuperview()
            make.width.equalTo(coverImageView.snp.height).multipliedBy(0.7)
        }
        
        bookmarkImageView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView)
            make.trailing.equalTo(coverImageView).inset(4)
            make.width.equalTo(coverImageView).multipliedBy(0.2)
            make.height.equalTo(bookmarkImageView.snp.width).multipliedBy(1.2)
        }
        
        infoTextStackView.snp.makeConstraints { make in
            make.top.trailing.equalTo(backdropView.layoutMarginsGuide)
            make.leading.equalTo(coverImageView.snp.trailing).offset(12)
            make.bottom.lessThanOrEqualTo(backdropView.layoutMarginsGuide)
        }
    }
}
