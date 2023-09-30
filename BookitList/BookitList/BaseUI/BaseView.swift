//
//  BaseView.swift
//  BookitList
//
//  Created by Roen White on 2023/09/30.
//

import UIKit

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        
        configureHiararchy()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHiararchy() {}
    func setConstraints() {}
}
