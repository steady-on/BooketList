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
            placeholderView.isHidden = true
            searchResultsCollectionView.isHidden = true
            noResultView.isHidden = true
            requiresConnectionView.isHidden = true
            
            switch state {
            case .enter:
                placeholderView.isHidden = false
            case .existSearchResult:
                searchResultsCollectionView.isHidden = false
            case .noSearchResult:
                noResultView.isHidden = false
            case .requiresConnection:
                requiresConnectionView.isHidden = false
            case .none:
                break
            }
            
            searchController.searchBar.searchTextField.isEnabled = requiresConnectionView.isHidden
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
    
    private let requiresConnectionView = BLDirectionView(symbolName: "wifi.slash", direction: "도서 검색은 인터넷 연결이 필요합니다.\n\n오프라인 상태에서 책을 등록하려면\n오른쪽 상단의 + 버튼을 눌러 책 정보를 직접 입력해주세요.")
    
    private let indicatorView = BLIndicatorView(direction: "책 가져오는 중...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        combine()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        configureNavigationBar()
        
        searchResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        searchResultsCollectionView.prefetchDataSource = self
        searchResultsCollectionView.keyboardDismissMode = .onDrag
        searchResultsCollectionView.bounces = false
        searchResultsCollectionView.backgroundColor = .background

        configureDataSource()
                
        let components = [placeholderView, searchResultsCollectionView, noResultView, indicatorView, requiresConnectionView]
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
        
        indicatorView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        requiresConnectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.5)
        }
    }
    
    private func combine() {
        viewModel.searchResultItems.bind { [weak self] items in
            self?.updateSnapshot()
            self?.state = items.isEmpty ? .noSearchResult : .existSearchResult
        }
        
        viewModel.isRequesting.bind { [weak self] bool in
            self?.indicatorView.isHidden = bool == false
        }
        
        viewModel.scrollToTop.bind { [weak self] bool in
            guard bool else { return }
            self?.searchResultsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        
        NetworkMonitor.shared.currentStatus.bind { [weak self] status in
            switch status {
            case .satisfied:
                self?.state = .enter
                self?.searchController.searchBar.searchTextField.isEnabled = true
            case .unsatisfied:
                self?.state = .requiresConnection
                self?.searchController.searchBar.searchTextField.isEnabled = false
                self?.presentNetworkAlert()
            case .none, .requiresConnection:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func presentNetworkAlert() {
        let alert = UIAlertController(title: "인터넷 연결 필요", message: "도서 검색은 인터넷 연결이 필요합니다. 오프라인 상태에서 책을 등록하려면 오른쪽 상단의 + 버튼을 눌러 책 정보를 직접 입력해주세요.", preferredStyle: .alert)
        
        let okay = UIAlertAction(title: "알겠어요!", style: .cancel)
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}

extension SearchBookViewController {
    fileprivate enum Section {
        case main
    }
    
    fileprivate enum State {
        case enter
        case existSearchResult
        case noSearchResult
        case requiresConnection
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
        guard var keyword = searchBar.text else { return }
        
        keyword = arrangeKeword(keyword)
        searchBar.text = keyword
        
        searchBar.resignFirstResponder()
        viewModel.requestSearchResult(for: keyword)
    }
    
    private func arrangeKeword(_ keyword: String) -> String {
        let words = keyword.components(separatedBy: " ").filter { $0.isEmpty == false }
        return words.joined(separator: " ")
    }
}

extension SearchBookViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths where indexPath.item == viewModel.resultItemCount - 2 {
            viewModel.requestNextPage()
        }
    }
}
