//
//  HomeViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import UIKit

final class ReadingRecordViewController: BaseViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(pushSearchBookView))
    }

    @objc private func pushSearchBookView() {
        let searchBookView = SearchBookViewController()
        searchBookView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchBookView, animated: true)
    }
}
