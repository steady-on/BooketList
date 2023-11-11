//
//  PrivacyPolicyViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/11.
//

import UIKit

final class TextModalViewController: BaseViewController {
    
    private let content: String
    
    init(content: String) {
        self.content = content
        
        super.init()
    }

    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.backgroundColor = .clear
        textView.isSelectable = false
        textView.isEditable = false
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
        navigationItem.title = "개인정보 처리방침"
        
        let confirm = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(confirmButtonTapped))
        
        navigationItem.rightBarButtonItem = confirm
    }
    
    @objc func confirmButtonTapped() {
        dismiss(animated: true)
    }
}
