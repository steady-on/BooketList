//
//  SearchBookViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/29.
//

import UIKit

final class SearchBookViewController: BaseViewController {
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "책제목, ISBN, 작가이름..."
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.returnKeyType = .search
        return searchController
    }()
    
    private let placeholderView = BLDirectionView(symbolName: "magnifyingglass", direction: "검색어를 입력해주세요.")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        configureNavigationBar()
        
        view.addSubview(placeholderView)
    }
    
    private func configureNavigationBar() {
        title = "도서 검색"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func setConstraints() {
        placeholderView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
}
