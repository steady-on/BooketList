//
//  BLSelectButtonFromEnum.swift
//  BookitList
//
//  Created by Roen White on 2023/10/10.
//

import UIKit

final class BLSelectButtonFromEnum<T: ButtonMakable & CaseIterable & RawRepresentable<Int>>: UIStackView {
    
    var seletedButtonTag: Int {
        guard let selectedButton = buttonGroup.first(where: { $0.isSelected }) else { return 0 }
        return selectedButton.tag
    }
    
    private let title: String
    private let baseEnum: T.Type
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var buttonGroup: [UIButton] = {
        var buttons = [UIButton]()

        baseEnum.allCases.forEach { buttonCase in
            let button = makeButton(title: buttonCase.buttonTitle, tag: buttonCase.rawValue)
            buttons.append(button)
        }
        
        buttons.first?.isSelected = true
        
        return buttons
    }()
    
    override var intrinsicContentSize: CGSize {
        let labelHeight = titleLabel.font.pointSize
        let stackHeight = buttonStackView.frame.height
        
        return CGSize(width: bounds.width, height: labelHeight + spacing + stackHeight)
    }
    
    init(title: String, baseEnum: T.Type) {
        self.title = title
        self.baseEnum = baseEnum
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
        spacing = 8
        alignment = .leading
        distribution = .fill
        
        titleLabel.text = title
        
        let components = [titleLabel, buttonStackView]
        components.forEach { component in
            addArrangedSubview(component)
        }
        
        buttonGroup.forEach { component in
            buttonStackView.addArrangedSubview(component)
            component.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        }
    }
    
    @objc private func buttonSelected(_ sender: UIButton) {
        buttonGroup.forEach { button in
            button.isSelected = button.tag == sender.tag
        }
    }
    
    private func makeButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.configuration = configureButton()
        button.setTitle(title, for: .normal)
        button.tintColor = .accent
        button.tag = tag
        return button
    }
    
    private func configureButton() -> UIButton.Configuration {
        var config = UIButton.Configuration.tinted()
        config.buttonSize = .small
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 6, leading: 8, bottom: 6, trailing: 8)
        return config
    }
}
