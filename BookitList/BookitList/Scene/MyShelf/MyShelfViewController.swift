//
//  BookShelfViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import UIKit

final class MyShelfViewController: BaseViewController {
    
    private let viewModel = MyShelfViewModel()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "책제목, 작가 이름..."
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.searchBar.returnKeyType = .search
//        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private let bookCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        view.addSubview(bookCollectionView)
    }
    
    override func setConstraints() {
        bookCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindComponentWithObservable() {
        
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "나의 서재"
        navigationItem.searchController = searchController
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(navigationSearchButtonTapped))

        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc private func navigationSearchButtonTapped() {
        searchController.searchBar.becomeFirstResponder()
    }
}
