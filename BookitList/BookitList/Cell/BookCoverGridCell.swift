//
//  NowReadingBookCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/17.
//

import UIKit
import Kingfisher

final class BookCoverGridCell: BaseCollectionViewCell {
    var book: Book! {
        didSet {
            configureComponents()
            remakeCoverImageViewConstraints()
            layoutIfNeeded()
        }
    }
    
    var detailInfoButtonHandler: (() -> Void)!
    var addNoteButtonHandler: (() -> Void)!
    
    private let coverImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let coverShadowView: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor = UIColor.systemGray.cgColor
        return view
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
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        // let symbolConfig = UIImage.SymbolConfiguration(paletteColors: [.white, .highlight])
//        let backgroundImage = UIImage(systemName: "play.circle.fill")?.withConfiguration(symbolConfig)
//        button.setBackgroundImage(backgroundImage, for: .normal)
        button.tintColor = .highlight
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "note.text.badge.plus")
        let symbolConfig = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .title1))
        config.preferredSymbolConfigurationForImage = symbolConfig
        button.configuration = config
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        accessoryView.isHidden = true
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverShadowView.layer.shadowPath = UIBezierPath(rect: coverShadowView.bounds).cgPath
    }
    
    override func configureHiararchy() {
        let components = [coverShadowView, coverImageView, accessoryView] // bottomAccessoryView
        components.forEach { component in
            contentView.addSubview(component)
        }
        
        let accessoryComponents = [titleLabel, playButton, detailInfoButton]
        accessoryComponents.forEach { component in
            accessoryView.addSubview(component)
        }
        
        detailInfoButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
//        let bottomAccessoryComponents = [readingProgressView, addReadingRecordButton, addNoteButton]
//        bottomAccessoryComponents.forEach { component in
//            bottomAccessoryView.addSubview(component)
//        }
        
        detailInfoButton.addTarget(self, action: #selector(detailInfoButtonTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
    }
    
    func toggleIsHiddenAccessaryView() {
        accessoryView.isHidden.toggle()
//        bottomAccessoryView.isHidden.toggle()
    }
    
    override func setConstraints() {
        coverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverShadowView.snp.makeConstraints { make in
            make.edges.equalTo(coverImageView)
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
        
//        bottomAccessoryView.snp.makeConstraints { make in
//            make.bottom.horizontalEdges.equalToSuperview()
//        }
        
//        readingProgressView.snp.makeConstraints { make in
//            make.top.horizontalEdges.equalToSuperview()
//        }
//        
//        addReadingRecordButton.snp.makeConstraints { make in
//            make.top.equalTo(readingProgressView.snp.bottom).offset(8)
//            make.leading.bottom.equalTo(bottomAccessoryView.layoutMarginsGuide)
//            make.width.equalToSuperview().dividedBy(8)
//            make.height.equalTo(detailInfoButton.snp.width).multipliedBy(1.2)
//        }
//        
//        addNoteButton.snp.makeConstraints { make in
//            make.centerY.equalTo(addReadingRecordButton)
//            make.trailing.equalTo(bottomAccessoryView.layoutMarginsGuide).offset(-4)
//            make.width.equalToSuperview().dividedBy(8)
//            make.height.equalTo(detailInfoButton.snp.width)
//        }
    }
    
    private func configureComponents() {
        let path = ImageFilePath.cover(bookID: book._id.stringValue)
        let url = ImageFileManager().makeFullFilePath(from: path)
        let provider = LocalFileImageDataProvider(fileURL: url)
        let placeholder = BLDirectionView(symbolName: "book.circle", direction: book.title)
        coverImageView.kf.setImage(with: provider, placeholder: placeholder)
        titleLabel.text = book.title
    }
    
    private func remakeCoverImageViewConstraints() {
        guard let imageSize = book.coverImageSize else { return }
        
        coverImageView.snp.remakeConstraints { make in
            make.height.equalTo(coverImageView.snp.width).multipliedBy(imageSize.height / imageSize.width)
            make.top.greaterThanOrEqualToSuperview()
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    @objc func detailInfoButtonTapped() {
        detailInfoButtonHandler()
    }
    
    @objc func addNoteButtonTapped() {
        addNoteButtonHandler()
    }
}
