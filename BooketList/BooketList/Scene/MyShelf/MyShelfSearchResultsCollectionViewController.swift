//
//  MyShelfSearchResultsCollectionViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/09.
//

import UIKit

class MyShelfSearchResultsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .tertiarySystemGroupedBackground
    }
}
