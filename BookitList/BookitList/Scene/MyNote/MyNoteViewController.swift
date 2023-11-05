//
//  MyNoteViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import UIKit

final class MyNoteViewController: BaseViewController {
    
    private let viewModel = MyNoteViewModel()
    
    private let searchResultsTableViewController = MyNoteSearchResultsTableViewController()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchBar.placeholder = "책제목, 노트내용..."
        searchController.searchBar.searchTextField.clearButtonMode = .always
        searchController.searchBar.returnKeyType = .search
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    private let noteTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private var noteDataSource: UITableViewDiffableDataSource<Int, Note>!
    
    private let placeholderView = BLDirectionView(symbolName: "doc", direction: "아직 작성된 노트가 없습니다.\n책을 읽으면서 여러가지 노트를 남겨보세요.\n아직 등록된 책이 없다면, 도서부터 등록해보세요!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchNotes()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        definesPresentationContext = true
        noteTableView.delegate = self
        configureNoteDataSource()
        
        let components = [noteTableView, placeholderView]
        components.forEach { component in
            view.addSubview(component)
        }
    }
    
    override func setConstraints() {
        noteTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        placeholderView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)            
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.title = "나의 노트"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(navigationSearchButtonTapped))

        navigationItem.rightBarButtonItem = searchButton
    }
    
    override func bindComponentWithObservable() {
        viewModel.noteArray.bind { [weak self] notes in
            self?.updateNoteSnapshot(for: notes)
            self?.placeholderView.isHidden = notes.isEmpty == false
            self?.searchController.searchBar.searchTextField.isEnabled = notes.isEmpty == false
        }
    }
    
    @objc private func navigationSearchButtonTapped() {
        searchController.searchBar.becomeFirstResponder()
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
        noteDataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MyNoteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else { return }
        searchResultsTableViewController.updateSnapshot(for: viewModel.searchNotes(for: keyword))
    }
}

extension MyNoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedNote = noteDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let editNoteViewController = EditNoteViewController(note: selectedNote) {
            guard let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell else { return }
            cell.note = selectedNote
        }
        let navigationController = UINavigationController(rootViewController: editNoteViewController)
        present(navigationController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
