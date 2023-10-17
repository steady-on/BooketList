//
//  SearchResultsCollectionViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/10/02.
//

import UIKit

final class SearchResultsCollectionViewController: UICollectionViewController {
    
    enum Section {
        case main
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SearchResultCollectionCell, Item> { cell, indexPath, itemIdentifier in
            cell.item = itemIdentifier
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier -> UICollectionViewCell in
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
