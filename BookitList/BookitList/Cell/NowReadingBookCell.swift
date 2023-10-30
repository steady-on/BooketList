//
//  NowReadingBookCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/17.
//

import UIKit
import Kingfisher

final class NowReadingBookCell: BaseCollectionViewCell {
    var book: Book! {
        didSet {
            let path = ImageFilePath.cover(bookID: book._id.stringValue)
            let url = ImageFileManager().makeFullFilePath(from: path)
            let provider = LocalFileImageDataProvider(fileURL: url)
            let placeholder = BLDirectionView(symbolName: "photo", direction: nil)
            coverImageView.kf.setImage(with: provider, placeholder: placeholder)
            titleLabel.text = book.title
        }
    }
    
    var detailInfoButtonHandler: (() -> Void)!
    
    private let coverImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let accessoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.isHidden = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(paletteColors: [.white, .highlight])
        let backgroundImage = UIImage(systemName: "play.circle.fill")?.withConfiguration(symbolConfig)
        button.setBackgroundImage(backgroundImage, for: .normal)
        button.tintColor = .highlight
        return button
    }()
    
    private let detailInfoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "info.circle"), for: .normal)
        return button
    }()
    
    private let bottomAccessoryView = {
        let view = UIView()
        view.backgroundColor = .secondaryBackground
        view.isHidden = true
        return view
    }()
    
    private let readingProgressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .white
        return progressView
    }()
    
    private let addReadingRecordButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(hierarchicalColor: .secondaryAccent)
        let image = UIImage.addBookmark.withConfiguration(symbolConfig)
        button.setBackgroundImage(image, for: .normal)
        return button
    }()
    
    private let addNoteButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "note.text.badge.plus"), for: .normal)
        button.tintColor = .secondaryAccent
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    override func configureHiararchy() {
        configureShadow()
    
        let components = [coverImageView, accessoryView, bottomAccessoryView]
        components.forEach { component in
            contentView.addSubview(component)
        }
        
        let accessoryComponents = [titleLabel, playButton, detailInfoButton]
        accessoryComponents.forEach { component in
            accessoryView.addSubview(component)
        }
        
        detailInfoButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        let bottomAccessoryComponents = [readingProgressView, addReadingRecordButton, addNoteButton]
        bottomAccessoryComponents.forEach { component in
            bottomAccessoryView.addSubview(component)
        }
        
        detailInfoButton.addTarget(self, action: #selector(detailInfoButtonTapped), for: .touchUpInside)
    }
    
    func toggleIsHiddenAccessaryView() {
        accessoryView.isHidden.toggle()
        bottomAccessoryView.isHidden.toggle()
    }
    
    override func setConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        accessoryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalTo(playButton.snp.width)
        }
        
        detailInfoButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(accessoryView.layoutMarginsGuide)
            make.width.equalToSuperview().dividedBy(9)
            make.height.equalTo(detailInfoButton.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(accessoryView.layoutMarginsGuide)
            make.trailing.lessThanOrEqualTo(detailInfoButton.snp.leading).offset(-8)
            make.height.greaterThanOrEqualTo(10)
        }
        
        bottomAccessoryView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        readingProgressView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        addReadingRecordButton.snp.makeConstraints { make in
            make.top.equalTo(readingProgressView.snp.bottom).offset(8)
            make.leading.bottom.equalTo(bottomAccessoryView.layoutMarginsGuide)
            make.width.equalToSuperview().dividedBy(8)
            make.height.equalTo(detailInfoButton.snp.width).multipliedBy(1.2)
        }
        
        addNoteButton.snp.makeConstraints { make in
            make.centerY.equalTo(addReadingRecordButton)
            make.trailing.equalTo(bottomAccessoryView.layoutMarginsGuide).offset(-4)
            make.width.equalToSuperview().dividedBy(8)
            make.height.equalTo(detailInfoButton.snp.width)
        }
    }
    
    private func configureShadow() {
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.masksToBounds = false
    }
    
    @objc func detailInfoButtonTapped() {
        detailInfoButtonHandler()
    }
}
