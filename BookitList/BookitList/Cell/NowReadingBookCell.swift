//
//  NowReadingBookCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/17.
//

import UIKit
import Kingfisher

class NowReadingBookCell: BaseCollectionViewCell {
    var book: Book! {
        didSet {
            let path = ImageFilePath.cover(bookID: book._id.stringValue, type: .full)
            let url = ImageFileManager().makeFullFilePath(from: path)
            coverImageButton.kf.setBackgroundImage(with: url, for: .normal)
            titleLabel.text = book.title
        }
    }
    
    private let coverImageButton = UIButton()
    
    private let accessoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
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
    
    override func configureHiararchy() {
        let components = [coverImageButton, accessoryView, bottomAccessoryView]
        components.forEach { component in
            contentView.addSubview(component)
        }
        
        let accessoryComponents = [titleLabel, playButton, detailInfoButton]
        accessoryComponents.forEach { component in
            accessoryView.addSubview(component)
        }
        
        detailInfoButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        accessoryView.isHidden = true
        
        let bottomAccessoryComponents = [readingProgressView, addReadingRecordButton, addNoteButton]
        bottomAccessoryComponents.forEach { component in
            bottomAccessoryView.addSubview(component)
        }
        
        coverImageButton.addTarget(self, action: #selector(coverImageButtonTapped), for: .touchUpInside)
    }
    
    @objc private func coverImageButtonTapped() {
        accessoryView.isHidden.toggle()
    }
    
    override func setConstraints() {
        coverImageButton.snp.makeConstraints { make in
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
            make.height.equalToSuperview().dividedBy(8)
        }
        
        readingProgressView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        addReadingRecordButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(bottomAccessoryView.layoutMarginsGuide)
            make.top.equalTo(readingProgressView.snp.bottom).offset(8)
            make.width.equalToSuperview().dividedBy(8)
            make.height.equalTo(detailInfoButton.snp.width)
        }
        
        addNoteButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(bottomAccessoryView.layoutMarginsGuide)
            make.top.equalTo(readingProgressView.snp.bottom).offset(8)
            make.width.equalToSuperview().dividedBy(8)
            make.height.equalTo(detailInfoButton.snp.width)
        }
    }
}
