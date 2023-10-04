//
//  BLIndicatorView.swift
//  BookitList
//
//  Created by Roen White on 2023/10/03.
//

import UIKit

class BLIndicatorView: BaseView {
    
    private let backdropView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 10
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8)
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .accent
        return indicator
    }()
    
    private let directionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(direction: String) {
        directionLabel.text = direction
        super.init()
    }
    
    override var isHidden: Bool {
        didSet {
            if isHidden == false {
                indicatorView.startAnimating()
            } else {
                indicatorView.stopAnimating()
            }
        }
    }
    
    override func configureHiararchy() {
        backgroundColor = .reverseBackground.withAlphaComponent(0.75)
        
        addSubview(backdropView)
        backdropView.addSubview(stackView)
        
        let components = [indicatorView, directionLabel]
        components.forEach { component in stackView.addArrangedSubview(component) }
    }
    
    override func setConstraints() {
        backdropView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.greaterThanOrEqualTo(backdropView.snp.width).multipliedBy(0.5)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(backdropView.layoutMarginsGuide)
        }
    }
}
