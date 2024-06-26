//
//  SimpleNoteCell.swift
//  BookitList
//
//  Created by Roen White on 2023/10/26.
//

import UIKit

class SimpleNoteCell: BaseTableViewCell, ReuseIdentifier {
    var note: Note! {
        didSet { configureComponents(for: note) }
    }
    
    private let backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    private let typeLabel = BLNoteTypeLabel(noteType: .quote)
    
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
    
    private let noteContentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.backgroundColor = .clear
        textView.textColor = .label
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    override func configureHiararchy() {
        backgroundColor = .clear
        addSubview(backdropView)
        
        let components = [typeLabel, pageLabel, createdAtLabel, noteContentTextView]
        components.forEach { component in
            backdropView.addSubview(component)
        }
        
        createdAtLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        pageLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    override func setConstraints() {
        backdropView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(5)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(backdropView.layoutMarginsGuide)
        }
        
        pageLabel.snp.makeConstraints { make in
            make.leading.equalTo(typeLabel.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(createdAtLabel.snp.leading).offset(-8)
            make.centerY.equalTo(typeLabel)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(backdropView.layoutMarginsGuide)
            make.centerY.equalTo(typeLabel)
        }
        
        noteContentTextView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(backdropView.layoutMarginsGuide)
            make.bottom.equalTo(backdropView.layoutMarginsGuide)
        }
    }
    
    private func configureComponents(for note: Note) {
        typeLabel.setNoteType(to: note.type)
        
        if let page = note.page {
            pageLabel.text = "P. \(page)"
        }
        
        createdAtLabel.text = note.createdAt.basicString
        noteContentTextView.text = note.content
    }
}
