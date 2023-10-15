//
//  BLSelectArtistFromArray.swift
//  BookitList
//
//  Created by Roen White on 2023/10/15.
//

import UIKit

final class BLSelectArtistFromArray: UIStackView {
    
    private let artists: [Artist]
    
    private lazy var buttonGroup: [UIButton] = {
        var buttons = [UIButton]()
        
        artists.forEach { artist in
            let button = makeButton(for: artist)
            buttons.append(button)
        }
        
        return buttons
    }()
    
    init(artists: [Artist]) {
        self.artists = artists
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        configureHiararchy()
    }
    
    private func configureHiararchy() {
        axis = .vertical
        spacing = 4
        alignment = .fill
        
        buttonGroup.forEach { button in
            addArrangedSubview(button)
            button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        }
    }
    
    @objc private func buttonSelected(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    private func makeButton(for artist: Artist) -> UIButton {
        let button = UIButton()
        
        var config = UIButton.Configuration.tinted()
        config.title = artist.authorName
        config.subtitle = artist.authorTypeDesc
        
        button.configuration = config
        return button
    }
}
