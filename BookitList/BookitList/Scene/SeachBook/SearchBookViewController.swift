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
    
    private let ebookButton: UIButton = {
        let button = UIButton()
        button.setTitle(" e-book 검색하기", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        button.tintColor = .systemGray
        
        return button
    }()
    
    private let placeholderView = BLDirectionView(symbolName: "magnifyingglass", direction: "검색어를 입력해주세요.")

    private var searchResultsCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private let noResultView = BLDirectionView(symbolName: "tray", direction: "검색 결과가 없습니다.\n책제목, ISBN, 작가이름으로 검색어를 입력해주세요.")
    
    private let requiresConnectionView = BLDirectionView(symbolName: "wifi.slash", direction: "도서 검색은 인터넷 연결이 필요합니다.\n\n오프라인 상태에서 책을 등록하려면\n오른쪽 상단의 + 버튼을 눌러 책 정보를 직접 입력해주세요.")
    
    private let indicatorView = BLIndicatorView(direction: "책 가져오는 중...")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindComponentWithObservable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewModel.searchResultItems.value.isEmpty else { return }
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
                
        let components = [ebookButton, placeholderView, searchResultsCollectionView, noResultView, indicatorView, requiresConnectionView]
        components.forEach { component in view.addSubview(component!) }
        
        ebookButton.addTarget(self, action: #selector(ebookButtonClicked), for: .touchUpInside)
        
        state = .enter
    }
    
    private func configureNavigationBar() {
        title = "도서 검색"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func ebookButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    override func setConstraints() {
        ebookButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        placeholderView.snp.makeConstraints { make in
            make.top.equalTo(ebookButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        searchResultsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(ebookButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noResultView.snp.makeConstraints { make in
            make.top.equalTo(ebookButton.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        requiresConnectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    private func bindComponentWithObservable() {
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
                self?.presentCautionAlert(title: "인터넷 연결 필요", message: "도서 검색은 인터넷 연결이 필요합니다. 오프라인 상태에서 책을 등록하려면 오른쪽 상단의 + 버튼을 눌러 책 정보를 직접 입력해주세요.")
            case .none, .requiresConnection:
                break
            @unknown default:
                break
            }
        }
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
    private func configureCollectionView() {
        searchResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        searchResultsCollectionView.prefetchDataSource = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.keyboardDismissMode = .onDrag
        searchResultsCollectionView.bounces = false
        searchResultsCollectionView.backgroundColor = .background
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let cellHeight = CGFloat(144)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(cellHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        // TODO: 버전 대응: horizontal(layoutSize:subitem:count:) -> horizontal(layoutSize:repeatingSubitem:count:)
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
        viewModel.requestSearchResult(for: keyword, isEbookSearch: ebookButton.isSelected)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchResultsCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(ebookButton.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResultsCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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

extension SearchBookViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addBookDetailInfoView = AddBookDetailInfoViewController(itemID:  viewModel.selectedItemID(at: indexPath))
        
        navigationController?.pushViewController(addBookDetailInfoView, animated: true)
    }
}
