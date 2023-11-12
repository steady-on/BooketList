//
//  PrivacyPolicyViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/11.
//

import UIKit

final class TextModalViewController: BaseViewController {
    
    private let content: String
    
    init(title: String, content: String) {
        self.content = content
        
        super.init()
        navigationItem.title = title
    }

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.backgroundColor = .clear
        textView.isSelectable = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        view.addSubview(contentTextView)
        contentTextView.text = content
    }
    
    override func setConstraints() {
        contentTextView.snp.makeConstraints { make in
            make.edges.equalTo(view.layoutMarginsGuide)
        }
    }
    
    override func configureNavigationBar() {
        let confirm = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(confirmButtonTapped))
        
        navigationItem.rightBarButtonItem = confirm
    }
    
    @objc func confirmButtonTapped() {
        dismiss(animated: true)
    }
}
