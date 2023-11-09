//
//  BookShelfViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import UIKit
import RealmSwift

final class MyShelfViewController: BaseViewController {
    
    private let viewModel = MyShelfViewModel()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsCollectionViewController)
        searchController.searchBar.placeholder = "책제목, 작가 이름..."
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.searchBar.returnKeyType = .search
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private lazy var changeLayoutButton = {
        UIBarButtonItem(image: UIImage(systemName: "books.vertical.fill"), style: .plain, target: self, action: #selector(changeLayoutButtonTapped))
    }()
    
    private var bookCollectionView: UICollectionView! = nil
    private var dataSource: UICollectionViewDiffableDataSource<Int, Book>! = nil
    
    private var searchResultsCollectionViewController: MyShelfSearchResultsCollectionViewController!
    
    private var searchResultsDataSource: UICollectionViewDiffableDataSource<Int, Book>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchBooks()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()

        configureSearchResultsCollectionView()
        configureSearchResultsDataSource()
        
        configureNavigationBar()
        configureCollectionView()
        configureDataSource(for: .grid)
        
        
        view.addSubview(bookCollectionView)
    }
    
    override func setConstraints() {
        bookCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindComponentWithObservable() {
        viewModel.books.bind { [weak self] books in
            self?.updateSnapshot(for: books)
        }
        
        viewModel.layout.bind { [weak self] layout in
            self?.changeLayoutButton.image = UIImage(systemName: layout.nextLayoutIconName)
            self?.changeLayout(for: layout)
            self?.configureDataSource(for: layout)
            self?.updateSnapshot(for: self?.viewModel.books.value ?? [])
        }
        
        viewModel.caution.bind { [weak self] caution in
            guard caution.isPresent else { return }
            
            self?.presentCautionAlert(title: caution.title, message: caution.message)
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "나의 서재"
        navigationItem.searchController = searchController
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(navigationSearchButtonTapped))
        
        navigationItem.rightBarButtonItems = [searchButton, changeLayoutButton]
    }
    
    @objc private func navigationSearchButtonTapped() {
        searchController.searchBar.becomeFirstResponder()
    }
    
    @objc private func changeLayoutButtonTapped() {
        viewModel.changeLayout()
    }
}

extension MyShelfViewController {
    private func configureCollectionView() {
        bookCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createGridLayout())
        bookCollectionView.showsVerticalScrollIndicator = false
        bookCollectionView.showsHorizontalScrollIndicator = false
        bookCollectionView.backgroundColor = .tertiarySystemGroupedBackground
        bookCollectionView.delegate = self
    }
    
    private func changeLayout(for layout: CollectionLayoutStyle) {
        switch layout {
        case .grid:
            bookCollectionView.collectionViewLayout = createGridLayout()
        case .shelf:
            bookCollectionView.collectionViewLayout = createShelfLayout()
        case .list:
            bookCollectionView.collectionViewLayout = createListLayout()
        }
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/4))
        // TODO: 버전 대응: horizontal(layoutSize:subitem:count:) -> horizontal(layoutSize:repeatingSubitem:count:)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(28)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = .init(top: 16, leading: 28, bottom: 16, trailing: 28)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createShelfLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(30), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/4))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(-1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        section.interGroupSpacing = 20
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let cellHeight = CGFloat(152)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(cellHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource(for layout: CollectionLayoutStyle) {
        let gridCellRegistration = UICollectionView.CellRegistration<BookCoverGridCell, Book> { cell, indexPath, itemIdentifier in
            cell.book = itemIdentifier
        }
        
        let shelfCellRegistration = UICollectionView.CellRegistration<BookShelfCell, Book> { cell, indexPath, itemIdentifier in
            cell.book = itemIdentifier
        }
        
        let listCellRegistration = UICollectionView.CellRegistration<BookListCell, Book> { cell, indexPath, itemIdentifier in
            cell.book = itemIdentifier
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Book>(collectionView: bookCollectionView) { collectionView, indexPath, itemIdentifier in
            switch layout {
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: itemIdentifier)
            case .shelf:
                return collectionView.dequeueConfiguredReusableCell(using: shelfCellRegistration, for: indexPath, item: itemIdentifier)
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
    }
    
    private func updateSnapshot(for books: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Book>()
        snapshot.appendSections([0])
        snapshot.appendItems(books)
        dataSource.apply(snapshot)
    }
}

extension MyShelfViewController {
    private func configureSearchResultsCollectionView() {
        searchResultsCollectionViewController = MyShelfSearchResultsCollectionViewController(collectionViewLayout: createListLayout())
        
        searchResultsCollectionViewController.collectionView.delegate = self
    }
    
    private func configureSearchResultsDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BookListCell, Book> { cell, indexPath, itemIdentifier in
            cell.book = itemIdentifier
        }
        
        searchResultsDataSource = UICollectionViewDiffableDataSource<Int, Book>(collectionView: searchResultsCollectionViewController.collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func updateSearchResultsSnapshot(for books: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Book>()
        snapshot.appendSections([0])
        snapshot.appendItems(books)
        searchResultsDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension MyShelfViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedBook: Book?
        if collectionView === bookCollectionView {
            selectedBook = dataSource.itemIdentifier(for: indexPath)
        } else {
            selectedBook = searchResultsDataSource.itemIdentifier(for: indexPath)
        }
        
        guard let selectedBook else { return }
        
        let allRecordsForBookView = AllRecordsForBookViewController(objectID: selectedBook._id)
        allRecordsForBookView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(allRecordsForBookView, animated: true)
    }
}

extension MyShelfViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else { return }
        
        let searchResults = viewModel.searchBook(for: keyword)
        updateSearchResultsSnapshot(for: searchResults)
    }
}
