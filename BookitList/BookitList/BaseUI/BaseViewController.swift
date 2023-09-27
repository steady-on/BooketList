//
//  BaseViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHiararchy()
        setConstraints()
    }

    func configureHiararchy() {
        view.backgroundColor = .background
    }
    
    func setConstraints() {}
}

