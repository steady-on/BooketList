//
//  AllRecordsForBookViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/10/24.
//

import UIKit
import RealmSwift
import Kingfisher

class AllRecordsForBookViewController: BaseViewController {
    
    private let viewModel: AllRecordsForBokViewModel
    private let updateHandler: (() -> Void)?
    private let deleteHandler: (() -> Void)?
    
    init(objectID: ObjectId, updateHandler: (() -> Void)? = nil, deleteHandler: (() -> Void)? = nil) {
        self.viewModel = AllRecordsForBokViewModel(objectID: objectID)
        self.updateHandler = updateHandler
        self.deleteHandler = deleteHandler
        viewModel.loadBook()
        super.init()
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    private let backdropImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleToFill
        imageView.applyBlurEffect()
        imageView.backgroundColor = .systemFill
        return imageView
    }()
    
    private let coverImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryAccent
        imageView.layer.shadowColor = UIColor.systemGray.cgColor
        imageView.layer.shadowOffset = .init(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        return imageView
    }()
    
    private let allRecordsView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.directionalLayoutMargins = .init(top: 8, leading: 16, bottom: 16, trailing: 16)
        return view
    }()
    
    private lazy var statusOfReadingLabel: BLShowingMenuButtonFromEnum<StatusOfReading> = {
        BLShowingMenuButtonFromEnum(selectedCase: .notYet) { selectedCase in
            self.viewModel.updateStatusOfReading(to: selectedCase)
        }
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 2
        return label
    }()
    
    private let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let overviewButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .leading
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .preferredFont(forTextStyle: .body)
        titleContainer.foregroundColor = .label
        
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("책 소개", attributes: titleContainer)
        config.image = UIImage(systemName: "chevron.down")
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.contentInsets = .init(top: 7, leading: 0, bottom: 7, trailing: 12)
        button.configuration = config
        return button
    }()
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .callout)
        textView.backgroundColor = .clear
        textView.textColor = .secondaryLabel
        textView.textContainerInset = .zero
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.maximumNumberOfLines = 1
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }()
    
    private let noteTableHeaderView = BLTitleSupplementaryButton(title: "작성된 노트")
    
    private let emptyNoteView = BLDirectionView(symbolName: "note", direction: "아직 작성된 노트가 없습니다.")
    
    private let noteTableView: BLContentWrappingTableView = {
        let tableView = BLContentWrappingTableView()
        tableView.register(SimpleNoteCell.self, forCellReuseIdentifier: SimpleNoteCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private var noteDataSource: UITableViewDiffableDataSource<Int, Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureComponents(for: viewModel.book.value)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        coverImageView.layer.shadowPath = UIBezierPath(rect: coverImageView.bounds).cgPath
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        noteTableView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let contentComponents = [backdropImageView, allRecordsView, coverImageView, statusOfReadingLabel]
        contentComponents.forEach { component in
            contentView.addSubview(component)
        }
        
        let allRecordsComponents = [infoStackView, overviewButton, overviewTextView, noteTableHeaderView, noteTableView, emptyNoteView]
        allRecordsComponents.forEach { component in
            allRecordsView.addSubview(component)
        }
        
        overviewButton.addTarget(self, action: #selector(overviewButtonTapped), for: .touchUpInside)
        
        let infoStackComponents = [titleLabel, originalTitleLabel, authorLabel]
        infoStackComponents.forEach { component in
            infoStackView.addArrangedSubview(component)
        }
        
        configureNoteDataSource()
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.horizontalEdges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(backdropImageView.snp.width).multipliedBy(0.5)
        }
        
        allRecordsView.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).inset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.3)
            make.centerY.equalTo(backdropImageView.snp.bottom)
            make.leading.equalTo(contentView.layoutMarginsGuide).offset(8)
        }
        
        statusOfReadingLabel.snp.makeConstraints { make in
            make.leading.equalTo(coverImageView.snp.trailing).offset(16)
            make.bottom.equalTo(allRecordsView.snp.top).offset(-8)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.trailing.equalTo(allRecordsView.layoutMarginsGuide)
            make.leading.equalTo(coverImageView.snp.trailing).offset(16)
        }
        
        overviewButton.snp.makeConstraints { make in
            make.top.equalTo(coverImageView.snp.bottom).offset(16)
            make.leading.equalTo(allRecordsView.layoutMarginsGuide)
        }
        
        overviewTextView.snp.makeConstraints { make in
            make.top.equalTo(overviewButton.snp.bottom)
            make.horizontalEdges.equalTo(allRecordsView.layoutMarginsGuide)
        }
        
        noteTableHeaderView.snp.makeConstraints { make in
            make.top.equalTo(overviewTextView.snp.bottom).offset(16)
            make.leading.equalTo(allRecordsView.layoutMarginsGuide)
        }
        
        emptyNoteView.snp.makeConstraints { make in
            make.top.equalTo(noteTableHeaderView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        noteTableView.snp.makeConstraints { make in
            make.top.equalTo(noteTableHeaderView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(allRecordsView.layoutMarginsGuide)
        }
    }
    
    override func bindComponentWithObservable() {
        viewModel.book.bind { [weak self] book in
            self?.configureComponents(for: book)
            self?.remakeCoverImageViewConstraints(for: book.coverImageSize)
        }
        
        viewModel.notes.bind { [weak self] notes in
            self?.updateNoteSnapshot(for: notes)
            self?.emptyNoteView.isHidden = notes.isEmpty == false
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
    
    override func configureNavigationBar() {
        let addNoteButton = UIBarButtonItem(image: UIImage(systemName: "note.text.badge.plus"), style: .plain, target: self, action: #selector(addNoteButtonTapped))
        
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: configureMeatbolsMenu())
        
        navigationItem.rightBarButtonItems = [menuButton, addNoteButton]
    }
    
    private func configureComponents(for book: Book) {
        let imagePath = viewModel.checkCoverImagePath()
        let provider = LocalFileImageDataProvider(fileURL: imagePath)
        let placeholder = BLDirectionView(symbolName: "photo", direction: nil)
        backdropImageView.kf.setImage(with: provider, placeholder: placeholder)
        coverImageView.kf.setImage(with: provider, placeholder: placeholder)
        titleLabel.text = book.title
        originalTitleLabel.text = book.originalTitle
        
        let authors = Array(book.authors).filter { $0.isTracking }.map { $0.name }.joined(separator: ", ")
        authorLabel.text = authors
        statusOfReadingLabel.setSelectedCase(to: book.statusOfReading)
        overviewTextView.text = book.overview
    }
    
    private func remakeCoverImageViewConstraints(for size: ImageSize?) {
        guard let size else { return }
        
        coverImageView.snp.remakeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(size.height / size.width)
            make.centerY.equalTo(backdropImageView.snp.bottom)
            make.leading.equalTo(contentView.layoutMarginsGuide).offset(8)
        }
        
        scrollView.layoutIfNeeded()
    }
    
    @objc private func addNoteButtonTapped() {
        let writeNoteViewController = WriteNoteViewController(book: viewModel.book.value) { [weak self] in
            self?.viewModel.fetchNotes()
            self?.updateHandler?()
        }
        let navigationController = UINavigationController(rootViewController: writeNoteViewController)
        self.present(navigationController, animated: true)
    }
    
    @objc private func overviewButtonTapped() {
        let currentNumberOfLines = overviewTextView.textContainer.maximumNumberOfLines
        overviewTextView.textContainer.maximumNumberOfLines = currentNumberOfLines == 0 ? 1 : 0
        overviewTextView.invalidateIntrinsicContentSize()
    }
}

extension AllRecordsForBookViewController {
    private func configureMeatbolsMenu() -> UIMenu {
        let editBook = UIAction(title: "책 정보 수정", image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
            self?.moveToEditBookInfo()
        }
        
        let deleteBook = UIAction(title: "책 삭제", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.showDeleteBookAlert()
        }
        
        let menu = UIMenu(children: [editBook, deleteBook])
        return menu
    }
    
    private func moveToEditBookInfo() {
        let editBookDetailInfoView = EditBookDetailInfoViewController(for: viewModel.book.value)
        navigationController?.pushViewController(editBookDetailInfoView, animated: true)
    }
    
    private func showDeleteBookAlert() {
        let alert = UIAlertController(title: "이 책을 삭제하시겠습니까?", message: "책을 삭제하면, 책뿐만 아니라 이 책에 대해 작성된 모든 기록도 모두 사라집니다. 그래도 삭제 하시겠습니까?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deleteHandler?()
            self?.viewModel.deleteBook()
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(delete)
        
        present(alert, animated: true)
    }
}

extension AllRecordsForBookViewController {
    private func configureNoteDataSource() {
        noteDataSource = UITableViewDiffableDataSource<Int, Note>(tableView: noteTableView) { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleNoteCell.identifier) as? SimpleNoteCell else { return UITableViewCell() }
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

extension AllRecordsForBookViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedNote = noteDataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        let editNoteViewController = EditNoteViewController(note: selectedNote) { [weak self] in
            guard let cell = tableView.cellForRow(at: indexPath) as? SimpleNoteCell else { return }
            cell.note = selectedNote
            self?.viewModel.fetchNotes()
        }
        let navigationController = UINavigationController(rootViewController: editNoteViewController)
        present(navigationController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let selectedNote = noteDataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            self?.showDeleteNoteAlert(for: selectedNote)
        }
        delete.image = UIImage(systemName: "trash")
        
        let actionConfig = UISwipeActionsConfiguration(actions: [delete])
        return actionConfig
    }
}

extension AllRecordsForBookViewController {
    private func showDeleteNoteAlert(for note: Note) {
        let alert = UIAlertController(title: "노트 삭제", message: "선택한 노트가 삭제되며, 삭제된 노트는 되돌릴 수 없습니다. 그래도 삭제하시겠습니까?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] action in
            self?.deleteNote(for: note)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }
    
    private func deleteNote(for note: Note) {
        var newSnapshot = noteDataSource.snapshot()
        newSnapshot.deleteItems([note])
        noteDataSource.apply(newSnapshot)
        viewModel.deleteNotes(for: note)
    }
    
    // TODO: 버전 대응
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        coverImageView.layer.shadowColor = UIColor.systemGray.cgColor
    }
}
