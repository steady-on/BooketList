//
//  BookListCell.swift
//  BookitList
//
//  Created by Roen White on 2023/11/08.
//

import UIKit
import Kingfisher

final class BookListCell: BaseCollectionViewCell {
    
    var book: Book! {
        didSet {
            configureComponents()
            remakeCoverImageViewConstraints(for: book.coverImageSize)
        }
    }
    
    private let backdropView: UIView = {
        let view = UIView()
        view.directionalLayoutMargins = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        return view
    }()
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.systemGray.cgColor
        imageView.layer.shadowOffset = .init(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        return imageView
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        label.lineBreakStrategy = .pushOut
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let publishInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let noteCountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let statusOfReadingLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let placeholder = BLDirectionView(symbolName: "photo", direction: nil)
    
    override func configureHiararchy() {
        backgroundColor = .tertiarySystemBackground
        
        addSubview(backdropView)
        
        let components = [coverImageView, infoStackView, divider]
        components.forEach { component in
            backdropView.addSubview(component)
        }
        
        let infoStackComponents = [titleLabel, authorLabel, publishInfoLabel, noteCountLabel, statusOfReadingLabel]
        infoStackComponents.forEach { component in
            infoStackView.addArrangedSubview(component)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverImageView.layer.shadowPath = UIBezierPath(rect: coverImageView.bounds).cgPath
    }
    
    override func setConstraints() {
        backdropView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(backdropView.layoutMarginsGuide)
            make.width.equalTo(backdropView.layoutMarginsGuide).multipliedBy(0.25)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.3)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.trailing.equalTo(backdropView.layoutMarginsGuide)
            make.leading.equalTo(coverImageView.snp.trailing).offset(16)
            make.bottom.lessThanOrEqualTo(backdropView.layoutMarginsGuide)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.centerX.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(backdropView.layoutMarginsGuide)
        }
    }
    
    private func configureComponents() {
        guard let book else { return }
        
        let imagePath = ImageFilePath.cover(bookID: book._id.stringValue)
        let url = ImageFileManager().makeFullFilePath(from: imagePath)
        let provider = LocalFileImageDataProvider(fileURL: url)
        coverImageView.kf.setImage(with: provider, placeholder: placeholder)
        
        titleLabel.text = book.title
        
        let authors = Array(book.authors).filter { $0.isTracking }.map { $0.name }.joined(separator: ", ")
        authorLabel.text = authors
        
        let publishInfo = [book.publisher, book.publishedAt].compactMap { $0 }.joined(separator: " | ")
        publishInfoLabel.text = publishInfo
        
        noteCountLabel.text = "작성된 노트 \(book.notes.count)개"
        statusOfReadingLabel.text = book.statusOfReading.title
        statusOfReadingLabel.textColor = book.statusOfReading.color
    }
    
    private func remakeCoverImageViewConstraints(for size: ImageSize?) {
        guard let size else { return }
        
        coverImageView.snp.remakeConstraints { make in
            coverImageView.snp.makeConstraints { make in
                make.top.leading.equalTo(backdropView.layoutMarginsGuide)
                make.width.equalTo(backdropView.layoutMarginsGuide).multipliedBy(0.25)
                make.height.equalTo(coverImageView.snp.width).multipliedBy(size.height / size.width)
                make.bottom.lessThanOrEqualTo(backdropView.layoutMarginsGuide)
            }
        }
    }
}
