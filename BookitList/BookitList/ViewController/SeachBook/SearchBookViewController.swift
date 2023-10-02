//
//  SearchBookViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/29.
//

import UIKit

final class SearchBookViewController: BaseViewController {
    
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
        return searchController
    }()
    
    private let placeholderView = BLDirectionView(symbolName: "magnifyingglass", direction: "검색어를 입력해주세요.")

    private var searchResultsCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let noResultView = BLDirectionView(symbolName: "tray", direction: "검색 결과가 없습니다.\n책제목, ISBN, 작가이름으로 검색어를 입력해주세요.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        definesPresentationContext = true
        
        configureNavigationBar()
        
        searchResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        searchResultsCollectionView.backgroundColor = .background
        configureDataSource()
        
        let components = [placeholderView, searchResultsCollectionView, noResultView]
        components.forEach { component in view.addSubview(component!) }
        
        state = .enter
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
        let estimatedHeight = CGFloat(152)
        let spacing = CGFloat(8)
        
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BLSearchResultCollectionCell, Item> { cell, indexPath, itemIdentifier in
            cell.item = itemIdentifier
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: searchResultsCollectionView) { collectionView, indexPath, itemIdentifier -> UICollectionViewCell in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func updateSnapshot(for newItems: [Item]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(newItems)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
