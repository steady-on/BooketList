//
//  BLTitleSupplementaryButton.swift
//  BookitList
//
//  Created by Roen White on 2023/10/23.
//

import UIKit

final class BLTitleSupplementaryButton: UIButton {
    let title: String
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentHorizontalAlignment = .leading
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .preferredFont(forTextStyle: .title3)
        titleContainer.foregroundColor = .label
        
        var config = UIButton.Configuration.plain()
        config.buttonSize = .large
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.attributedTitle = AttributedString(title, attributes: titleContainer)
        configuration = config
    }
}
