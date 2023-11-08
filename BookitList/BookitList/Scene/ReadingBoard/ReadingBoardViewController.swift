//
//  HomeViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import UIKit
import RealmSwift

final class ReadingBoardViewController: BaseViewController {
    
    private let viewModel = ReadingBoardViewModel()
    
    private let nowReadingBookTitleButton = BLTitleSupplementaryButton(title: "지금, 읽고 있는 책")
    private var nowReadingBookCollectionView: UICollectionView! = nil
    private var nowReadingBookdataSource: UICollectionViewDiffableDataSource<Int, Book>! = nil
    
    private let waitingBookTitleButton = BLTitleSupplementaryButton(title: "나의 북킷리스트")
    private var waitingBookCollectionView: UICollectionView! = nil
    private var waitingBookDataSource: UICollectionViewDiffableDataSource<Int, Book>! = nil
    
    private let placeholderView = BLDirectionView(symbolName: "book", direction: "아직 등록된 책이 없습니다.\n오른쪽 위의 돋보기 버튼을 눌러 책을 검색하고 추가해 보세요.")
    private let emptyNowReadingBookView = BLDirectionView(symbolName: "book", direction: "지금 읽고 있는 책이 없습니다.\n아래의 책꽂이에서 읽을 책을 골라보세요.")
    private let emptyWaitingBookView = BLDirectionView(symbolName: "books.vertical", direction: "아직 읽지 않은 상태의 책이 없습니다.")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchBooks()
        placeholderView.isHidden = viewModel.isEmptyBooks == false
        
        if viewModel.isEmptyBooks == false {
            nowReadingBookCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        }
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        configureCollectionView()
        
        let components = [nowReadingBookTitleButton, nowReadingBookCollectionView, waitingBookTitleButton, waitingBookCollectionView, emptyNowReadingBookView, emptyWaitingBookView, placeholderView]
        components.forEach { component in
            guard let component else { return }
            view.addSubview(component)
        }
        
        configureDataSource()
    }
    
    override func setConstraints() {
        nowReadingBookTitleButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.layoutMarginsGuide)
        }
        
        nowReadingBookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nowReadingBookTitleButton.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.55)
        }
        
        waitingBookTitleButton.snp.makeConstraints { make in
            make.top.equalTo(nowReadingBookCollectionView.snp.bottom)
            make.leading.equalTo(view.layoutMarginsGuide)
        }
        
        waitingBookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(waitingBookTitleButton.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyNowReadingBookView.snp.makeConstraints { make in
            make.edges.equalTo(nowReadingBookCollectionView)
        }
        
        emptyWaitingBookView.snp.makeConstraints { make in
            make.edges.equalTo(waitingBookCollectionView)
        }
        
        placeholderView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(pushSearchBookView))
    }

    @objc private func pushSearchBookView() {
        let searchBookView = SearchBookViewController()
        searchBookView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchBookView, animated: true)
    }
    
    override func bindComponentWithObservable() {
        viewModel.nowReadingBooks.bind { [weak self] books in
            guard let viewModel = self?.viewModel else { return }
            self?.updateNowReadingBooksSnapshot(for: books)
            self?.emptyNowReadingBookView.isHidden = viewModel.isEmptyNowReadingBooks == false
            self?.nowReadingBookTitleButton.isEnabled = viewModel.isEmptyNowReadingBooks == false
        }
        
        viewModel.waitingBooks.bind { [weak self] books in
            guard let viewModel = self?.viewModel else { return }
            self?.updateWaitingBooksSnapshot(for: books)
            self?.emptyWaitingBookView.isHidden = viewModel.isEmptyWaitingBooks == false
            self?.waitingBookTitleButton.isEnabled = viewModel.isEmptyWaitingBooks == false
        }
        
        viewModel.caution.bind { [weak self] caution in
            guard caution.isPresent else { return }
            
            let popViewAction = { () -> Void in
                self?.navigationController?.popViewController(animated: true)
            }
            
            let handler: () -> Void = caution.willDismiss ? popViewAction : {}
            
            self?.presentCautionAlert(title: caution.title, message: caution.message, handler: handler)
        }
    }
}

extension ReadingBoardViewController {
    private func configureCollectionView() {
        nowReadingBookCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createReadingBooksLayout())
        nowReadingBookCollectionView.backgroundColor = .tertiarySystemGroupedBackground
        nowReadingBookCollectionView.isScrollEnabled = false
        nowReadingBookCollectionView.delegate = self
        
        waitingBookCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createWaitingBooksLayout())
        waitingBookCollectionView.backgroundColor = .background
        waitingBookCollectionView.isScrollEnabled = false
        waitingBookCollectionView.delegate = self
    }
    
    private func createReadingBooksLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 35, bottom: 0, trailing: 35)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(1))
        // TODO: 버전 대응: horizontal(layoutSize:subitem:count:) -> horizontal(layoutSize:repeatingSubitem:count:)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = .init(top: 20, leading: 0, bottom: 20, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createWaitingBooksLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(30), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(5.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(-1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureDataSource() {
        let nowReadingBookCellRegistration = UICollectionView.CellRegistration<NowReadingBookCell, Book> { cell, indexPath, itemIdentifier in
            cell.book = itemIdentifier
            cell.detailInfoButtonHandler = {
                let allRecordsForBookView = AllRecordsForBookViewController(book: itemIdentifier)
                allRecordsForBookView.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(allRecordsForBookView, animated: true)
            }
            cell.addNoteButtonHandler = {
                let writeNoteViewController = WriteNoteViewController(book: itemIdentifier)
                let navigationController = UINavigationController(rootViewController: writeNoteViewController)
                self.present(navigationController, animated: true)
            }
        }
        
        nowReadingBookdataSource = UICollectionViewDiffableDataSource<Int, Book>(collectionView: nowReadingBookCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: nowReadingBookCellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        let waitingBookCellRegistration = UICollectionView.CellRegistration<WaitingBookCell, Book> { cell, indexPath, itemIdentifier in
            cell.book = itemIdentifier
        }

        waitingBookDataSource = UICollectionViewDiffableDataSource<Int, Book>(collectionView: waitingBookCollectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: waitingBookCellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    private func updateNowReadingBooksSnapshot(for books: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Book>()
        snapshot.appendSections([0])
        snapshot.appendItems(books)
        nowReadingBookdataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func updateWaitingBooksSnapshot(for books: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Book>()
        snapshot.appendSections([0])
        snapshot.appendItems(books)
        waitingBookDataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ReadingBoardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == nowReadingBookCollectionView {
            guard let cell = collectionView.cellForItem(at: indexPath) as? NowReadingBookCell else { return }
            cell.toggleIsHiddenAccessaryView()
            return
        }
        
        guard let book = waitingBookDataSource.itemIdentifier(for: indexPath) else { return }
        let allRecordsForBookView = AllRecordsForBookViewController(book: book)
        allRecordsForBookView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(allRecordsForBookView, animated: true)
    }
}
