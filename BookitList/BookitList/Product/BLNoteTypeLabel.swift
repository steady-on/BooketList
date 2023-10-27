//
//  BLNoteTypeLabel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/26.
//

import UIKit

final class BLNoteTypeLabel: BaseView {
    
    private var noteType: NoteType
    
    private let typeLabel = UILabel()
    private let iconImage = UIImageView()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private var labelColor: UIColor {
        switch noteType {
        case .quote: return .blBlue
        case .summary: return .blGray
        case .thinking: return .blGreen
        case .question: return .blRed
        case .report: return .blYellow
        case .memory: return .blBrown
        }
    }
    
    private var iconImageName: String {
        switch noteType {
        case .quote: return "bookmark.fill"
        case .summary: return "doc.append"
        case .thinking: return "ellipsis.bubble"
        case .question: return "questionmark.circle"
        case .report: return "doc.text"
        case .memory: return "calendar"
        }
    }
    
    init(noteType: NoteType) {
        self.noteType = noteType
        super.init()
    }
    
    override func configureHiararchy() {
        layer.cornerRadius = 5
        clipsToBounds = true
        backgroundColor = labelColor.withAlphaComponent(0.1)
        directionalLayoutMargins = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        configureIconImage()
        configureTypeLabel()
        
        addSubview(stackView)
        
        let components = [iconImage, typeLabel]
        components.forEach { component in
            stackView.addArrangedSubview(component)
        }
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(layoutMarginsGuide)
        }
    }
    
    private func configureTypeLabel() {
        typeLabel.text = noteType.title
        typeLabel.font = .preferredFont(forTextStyle: .callout)
        typeLabel.textColor = labelColor
    }
    
    private func configureIconImage() {
        let symbolConfig = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .callout))
        iconImage.image = UIImage(systemName: iconImageName, withConfiguration: symbolConfig)
        iconImage.tintColor = labelColor
    }
    
    private func updateLayout() {
        configureTypeLabel()
        configureIconImage()
        backgroundColor = labelColor.withAlphaComponent(0.1)
    }
    
    func setNoteType(to noteType: NoteType) {
        self.noteType = noteType
        updateLayout()
    }
}
