//
//  MyNoteSearchResultsTableViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/05.
//

import UIKit

class MyNoteSearchResultsTableViewController: UITableViewController {
    
    private var searchResultsDataSource: UITableViewDiffableDataSource<Int, Note>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureNoteDataSource()
    }
    
    private func configureTableView() {
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func configureNoteDataSource() {
        searchResultsDataSource = UITableViewDiffableDataSource<Int, Note>(tableView: tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier) as? NoteTableViewCell else { return UITableViewCell() }
            cell.note = itemIdentifier
            return cell
        }
    }
    
    func updateSnapshot(for notes: [Note]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Note>()
        snapshot.appendSections([0])
        snapshot.appendItems(notes)
        searchResultsDataSource.apply(snapshot, animatingDifferences: true)
    }
}
