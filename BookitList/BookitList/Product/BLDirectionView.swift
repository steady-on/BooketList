//
//  BLDirectionView.swift
//  BookitList
//
//  Created by Roen White on 2023/10/01.
//

import UIKit
import SnapKit

final class BLDirectionView: BaseView {
    private let symbolImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .placeholderText
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let directionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .placeholderText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    init(symbolName: String, direction: String) {
        self.symbolImageView.image = UIImage(systemName: symbolName)
        self.directionLabel.text = direction
        
        super.init()
    }
    
    override func configureHiararchy() {
        addSubview(stackView)
        let components = [symbolImageView, directionLabel]
        components.forEach { component in stackView.addArrangedSubview(component) }
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.lessThanOrEqualTo(layoutMarginsGuide)
        }
        
        symbolImageView.snp.makeConstraints { make in
            make.width.equalTo(layoutMarginsGuide).multipliedBy(0.25)
            make.height.equalTo(symbolImageView.snp.width)
        }
    }
}