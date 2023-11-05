//
//  MyNoteViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import UIKit

final class MyNoteViewController: BaseViewController {
    
    private let viewModel = MyNoteViewModel()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "책제목, 노트내용..."
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.returnKeyType = .search
        return searchController
    }()
    
    private let noteTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var noteDataSource: UITableViewDiffableDataSource<Int, Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchNotes()
        updateNoteSnapshot(for: viewModel.notes.value)
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        configureNoteDataSource()
        
        view.addSubview(noteTableView)
    }
    
    override func setConstraints() {
        noteTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "나의 노트"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
}

extension MyNoteViewController {
    private func configureNoteDataSource() {
        noteDataSource = UITableViewDiffableDataSource<Int, Note>(tableView: noteTableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier) as? NoteTableViewCell else { return UITableViewCell() }
            cell.note = itemIdentifier
            return cell
        }
    }
    
    private func updateNoteSnapshot(for notes: [Note]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Note>()
        snapshot.appendSections([0])
        snapshot.appendItems(notes)
        noteDataSource.apply(snapshot, animatingDifferences: true)
    }
}
