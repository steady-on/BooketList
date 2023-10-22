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
    
    private let waitingBookTitleButton = BLTitleSupplementaryButton(title: "읽으려고 꽂아둔 책")
    private var waitingBookCollectionView: UICollectionView! = nil
    private var waitingBookDataSource: UICollectionViewDiffableDataSource<Int, Book>! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchBooks()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        configureNavigationBar()
        configureCollectionView()
        
        let components = [nowReadingBookTitleButton, nowReadingBookCollectionView, waitingBookTitleButton, waitingBookCollectionView]
        components.forEach { component in
            guard let component else { return }
            view.addSubview(component)
        }
        
        configureDataSource()
    }
    
    override func setConstraints() {
        nowReadingBookTitleButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        nowReadingBookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nowReadingBookTitleButton.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.55)
        }
        
        waitingBookTitleButton.snp.makeConstraints { make in
            make.top.equalTo(nowReadingBookCollectionView.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        waitingBookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(waitingBookTitleButton.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(pushSearchBookView))
    }

    @objc private func pushSearchBookView() {
        let searchBookView = SearchBookViewController()
        searchBookView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchBookView, animated: true)
    }
    
    override func bindComponentWithObservable() {
        viewModel.nowReadingBooks.bind { [weak self] books in
            self?.updateNowReadingBooksSnapshot(for: books)
        }
        
        viewModel.waitingBooks.bind { [weak self] books in
            self?.updateWaitingBooksSnapshot(for: books)
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
        waitingBookCollectionView.backgroundColor = .tertiarySystemGroupedBackground
        waitingBookCollectionView.isScrollEnabled = false
        waitingBookCollectionView.delegate = self
    }
    
    private func createReadingBooksLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(1))
        // TODO: 버전 대응: horizontal(layoutSize:subitem:count:) -> horizontal(layoutSize:repeatingSubitem:count:)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let sideSpacing = view.bounds.width * 0.09
        group.contentInsets = .init(top: 20, leading: sideSpacing, bottom: 20, trailing: sideSpacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: config)
        
        return layout
    }
    
    private func createWaitingBooksLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(30), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(3.0), heightDimension: .fractionalHeight(1.0))
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? NowReadingBookCell else { return }
        
        cell.toggleIsHiddenAccessaryView()
    }
}
