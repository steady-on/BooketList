//
//  ReadingRecordCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/26.
//

import UIKit

final class ReadingRecordCell: BaseCollectionViewCell {
    
    var readingHistory: ReadingHistory! {
        didSet {
            // TODO: cell configure
        }
    }
    
    private let backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemGray2.cgColor
        view.layer.borderWidth = 0.5
        view.directionalLayoutMargins = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .preferredFont(forTextStyle: .callout)
        textView.textContainerInset = .zero
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.maximumNumberOfLines = 3
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    private let rateButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        
        let symbolConfig = UIImage.SymbolConfiguration(textStyle: .caption1)
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 4)
        config.image = UIImage(systemName: "star.fill", withConfiguration: symbolConfig)
        config.imagePadding = 4
        config.buttonSize = .small
        button.configuration = config
        return button
    }()
    
    override func configureHiararchy() {
        backgroundColor = .clear
        
        addSubview(backdropView)
        backdropView.addSubview(contentStackView)
        
        let components = [titleLabel, periodLabel, reviewTextView, rateButton]
        components.forEach { component in
            contentStackView.addArrangedSubview(component)
        }
        
        reviewTextView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        periodLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    
    override func setConstraints() {
        backdropView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalTo(backdropView.layoutMarginsGuide)
        }
    }
}
