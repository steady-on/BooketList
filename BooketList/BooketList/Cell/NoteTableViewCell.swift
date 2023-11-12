//
//  NoteTableViewCell.swift
//  BookitList
//
//  Created by Roen White on 2023/11/04.
//

import UIKit
import Kingfisher

class NoteTableViewCell: BaseTableViewCell, ReuseIdentifier {
    var note: Note! {
        didSet { configureComponents(for: note) }
    }
    
    private let placeholder = BLDirectionView(symbolName: "photo", direction: nil)
    
    private let backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.clipsToBounds = true
        return view
    }()
        
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.kf.indicatorType = .activity
        imageView.layer.shadowColor = UIColor.systemGray.cgColor
        imageView.layer.shadowOffset = .init(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let typeLabel = BLNoteTypeLabel(noteType: .quote)
    
    private let noteContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        return stackView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.backgroundColor = .clear
        textView.textColor = .label
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        pageLabel.text = nil
    }
    
    override func configureHiararchy() {
        backgroundColor = .clear
        directionalLayoutMargins = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        addSubview(backdropView)
        
        let backdropComponents = [noteContentView, coverImageView, typeLabel]
        backdropComponents.forEach { component in
            backdropView.addSubview(component)
        }
        
        let noteContentComponents = [infoStackView, contentTextView]
        noteContentComponents.forEach { component in
            noteContentView.addSubview(component)
        }
        
        let infoStackComponents = [titleLabel, pageLabel, createdAtLabel]
        infoStackComponents.forEach { component in
            infoStackView.addArrangedSubview(component)
        }
    }
    
    override func setConstraints() {
        backdropView.snp.makeConstraints { make in
            make.edges.equalTo(layoutMarginsGuide)
        }

        coverImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.3)
            make.top.equalToSuperview()
            make.leading.equalTo(backdropView.layoutMarginsGuide)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }
        
        noteContentView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(noteContentView.snp.top).offset(8)
            make.leading.equalTo(coverImageView.snp.trailing).offset(16)
            make.trailing.equalTo(noteContentView.layoutMarginsGuide)
        }
                
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(noteContentView.layoutMarginsGuide)
            make.bottom.equalTo(noteContentView.layoutMarginsGuide)
        }
    }
    
    private func configureComponents(for note: Note) {
        guard let book = note.book.first else { return }
        
        let imagePath = ImageFilePath.cover(bookID: book._id.stringValue)
        let url = ImageFileManager().makeFullFilePath(from: imagePath)
        let provider = LocalFileImageDataProvider(fileURL: url)
        coverImageView.kf.setImage(with: provider, placeholder: placeholder)
        typeLabel.setNoteType(to: note.type)
        titleLabel.text = book.title
        
        let authors = Array(book.authors).filter { $0.isTracking }.map { $0.name }.joined(separator: ", ")
        authorLabel.text = authors
        
        if let page = note.page {
            pageLabel.text = "P. \(page)"
        }
        
        createdAtLabel.text = note.createdAt.basicString
        contentTextView.text = note.content
    }
    
    // TODO: 버전 대응
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        coverImageView.layer.shadowColor = UIColor.systemGray.cgColor
    }
}
