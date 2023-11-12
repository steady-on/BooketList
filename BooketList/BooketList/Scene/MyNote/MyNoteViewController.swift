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
    private var searchResultsDataSource: UITableViewDiffableDataSource<Int, Note>!
    private var searchResultsSnapshot = NSDiffableDataSourceSnapshot<Int, Note>()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultsTableViewController)
        searchController.searchBar.placeholder = "책 제목, 작가이름, 노트내용..."
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
    private var noteSnapshot = NSDiffableDataSourceSnapshot<Int, Note>()
    
    private let placeholderView = BLDirectionView(symbolName: "doc", direction: "아직 작성된 노트가 없습니다.\n책을 읽으면서 여러가지 노트를 남겨보세요.\n아직 등록된 책이 없다면, 도서부터 등록해보세요!")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSnapshot(for: [])
        viewModel.fetchNotes()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        searchResultsTableViewController.tableView.delegate = self
        configureSearchResultsDataSource()
        
        
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
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.and.text.magnifyingglass"), style: .plain, target: self, action: #selector(navigationSearchButtonTapped))

        navigationItem.rightBarButtonItem = searchButton
    }
    
    override func bindComponentWithObservable() {
        viewModel.noteArray.bind { [weak self] notes in
            self?.updateSnapshot(for: notes)
            self?.placeholderView.isHidden = notes.isEmpty == false
            self?.searchController.searchBar.searchTextField.isEnabled = notes.isEmpty == false
        }
        
        viewModel.caution.bind { [weak self] caution in
            guard caution.isPresent else { return }
            
            self?.presentCautionAlert(title: caution.title, message: caution.message)
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
    
    private func updateSnapshot(for notes: [Note]) {
        noteSnapshot = NSDiffableDataSourceSnapshot<Int, Note>()
        noteSnapshot.appendSections([0])
        noteSnapshot.appendItems(notes)
        noteDataSource.apply(noteSnapshot, animatingDifferences: false)
    }
}

extension MyNoteViewController {
    private func configureSearchResultsDataSource() {
        searchResultsDataSource = UITableViewDiffableDataSource<Int, Note>(tableView: searchResultsTableViewController.tableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier) as? NoteTableViewCell else { return UITableViewCell() }
            cell.note = itemIdentifier
            return cell
        }
    }
    
    private func updateSearchResultsSnapshot(for notes: [Note]) {
        searchResultsSnapshot = NSDiffableDataSourceSnapshot<Int, Note>()
        searchResultsSnapshot.appendSections([0])
        searchResultsSnapshot.appendItems(notes)
        searchResultsDataSource.apply(searchResultsSnapshot, animatingDifferences: true)
    }
}

extension MyNoteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else { return }
        
        let searchResults = viewModel.searchNotes(for: keyword)
        updateSearchResultsSnapshot(for: searchResults)
    }
}

extension MyNoteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedNote: Note?
        
        if tableView === noteTableView {
            selectedNote = noteDataSource.itemIdentifier(for: indexPath)
        } else {
            selectedNote = searchResultsDataSource.itemIdentifier(for: indexPath)
        }

        guard let selectedNote else { return }
        
        let editNoteViewController = EditNoteViewController(note: selectedNote) { [weak self] in
            self?.updateTableViewCellData(tableView, data: selectedNote)
        }
        let navigationController = UINavigationController(rootViewController: editNoteViewController)
        present(navigationController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    private func updateTableViewCellData(_ tableView: UITableView, data: Note) {
        if tableView === searchResultsTableViewController.tableView {
            searchResultsSnapshot.reconfigureItems([data])
            searchResultsDataSource.apply(searchResultsSnapshot)
        }
        
        noteSnapshot.reconfigureItems([data])
        noteDataSource.apply(noteSnapshot)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedNote: Note?
        if tableView === noteTableView {
            selectedNote = noteDataSource.itemIdentifier(for: indexPath)
        } else {
            selectedNote = searchResultsDataSource.itemIdentifier(for: indexPath)
        }
        
        guard let selectedNote else { return UISwipeActionsConfiguration() }
        
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            self?.showDeleteNoteAlert(tableView, for: selectedNote)
        }
        delete.image = UIImage(systemName: "trash")
        
        let actionConfig = UISwipeActionsConfiguration(actions: [delete])
        return actionConfig
    }
}

extension MyNoteViewController {
    private func showDeleteNoteAlert(_ tableView: UITableView, for note: Note) {
        let alert = UIAlertController(title: "노트 삭제", message: "선택한 노트가 삭제되며, 삭제된 노트는 되돌릴 수 없습니다. 그래도 삭제하시겠습니까?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] action in
            self?.deleteNote(tableView, data: note)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
    
    private func deleteNote(_ tableView: UITableView, data: Note) {
        if tableView === searchResultsTableViewController.tableView {
            searchResultsSnapshot.deleteItems([data])
            searchResultsDataSource.apply(searchResultsSnapshot)
        }
        
        noteSnapshot.deleteItems([data])
        noteDataSource.apply(noteSnapshot)
    }
}
