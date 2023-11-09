//
//  MyShelfSearchResultsCollectionViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/09.
//

import UIKit

class MyShelfSearchResultsCollectionViewController: UICollectionViewController {
    
    private var searchResultsDataSource: UICollectionViewDiffableDataSource<Int, Book>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureDataSource()
    }
    
    private func configureCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BookListCell, Book> { cell, indexPath, itemIdentifier in
            cell.book = itemIdentifier
        }
        
        searchResultsDataSource = UICollectionViewDiffableDataSource<Int, Book>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    func updateSnapshot(for books: [Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Book>()
        snapshot.appendSections([0])
        snapshot.appendItems(books)
        searchResultsDataSource.apply(snapshot, animatingDifferences: true)
    }
}
