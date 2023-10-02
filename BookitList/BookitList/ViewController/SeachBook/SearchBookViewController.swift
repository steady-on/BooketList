//
//  SearchBookViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/29.
//

import UIKit

final class SearchBookViewController: BaseViewController {
    
    private let viewModel = SearchBookViewModel()
    
    private var state: State! {
        didSet {
            switch state {
            case .enter:
                placeholderView.isHidden = false
                searchResultsCollectionView.isHidden = true
                noResultView.isHidden = true
            case .existSearchResult:
                placeholderView.isHidden = true
                searchResultsCollectionView.isHidden = false
                noResultView.isHidden = true
            case .noSearchResult:
                placeholderView.isHidden = true
                searchResultsCollectionView.isHidden = true
                noResultView.isHidden = false
            case .none:
                break
            }
        }
    }
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "책제목, ISBN, 작가이름..."
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.becomeFirstResponder()
        return searchController
    }()
    
    private let placeholderView = BLDirectionView(symbolName: "magnifyingglass", direction: "검색어를 입력해주세요.")

    private var searchResultsCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let noResultView = BLDirectionView(symbolName: "tray", direction: "검색 결과가 없습니다.\n책제목, ISBN, 작가이름으로 검색어를 입력해주세요.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        combine()
        state = .enter
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        configureNavigationBar()
        
        searchResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        searchResultsCollectionView.backgroundColor = .background
        configureDataSource()
        
        let components = [placeholderView, searchResultsCollectionView, noResultView]
        components.forEach { component in view.addSubview(component!) }
    }
    
    private func configureNavigationBar() {
        title = "도서 검색"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func setConstraints() {
        placeholderView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
        
        searchResultsCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noResultView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
    
    private func combine() {
        viewModel.searchResultItems.bind { [weak self] items in
            self?.updateSnapshot()
            self?.state = items.isEmpty ? .noSearchResult : .existSearchResult
        }
    }
}

extension SearchBookViewController {
    enum Section {
        case main
    }
    
    enum State {
        case enter
        case existSearchResult
        case noSearchResult
    }
}

extension SearchBookViewController {
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let cellHeight = CGFloat(144)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(cellHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BLSearchResultCollectionCell, Item> { cell, indexPath, itemIdentifier in
            cell.item = itemIdentifier
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: searchResultsCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.searchResultItems.value)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SearchBookViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        searchBar.resignFirstResponder()
        viewModel.search(for: keyword)
    }
}
