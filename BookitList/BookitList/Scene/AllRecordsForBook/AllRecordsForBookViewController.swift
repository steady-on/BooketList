//
//  AllRecordsForBookViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/10/24.
//

import UIKit
import Kingfisher

class AllRecordsForBookViewController: BaseViewController {
    
    private let viewModel: AllRecordsForBokViewModel
    
    init(book: Book) {
        self.viewModel = AllRecordsForBokViewModel(book: book)
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
        imageView.layer.shadowOffset = .init(width: 3, height: 3)
        imageView.layer.shadowOpacity = 0.7
        // FIXME: shadowPath 설정
//        imageView.layer.shadowPath = UIBezierPath(ovalIn: renderRect).cgPath
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
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.numberOfLines = 3
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
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
        
        let infoStackComponents = [titleLabel, authorLabel]
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
        }
        
        viewModel.notes.bind { [weak self] notes in
            self?.updateNoteSnapshot(for: notes)
            self?.emptyNoteView.isHidden = notes.isEmpty == false
        }
    }
    
    override func configureNavigationBar() {
        let addNoteButton = UIBarButtonItem(image: UIImage(systemName: "note.text.badge.plus"), style: .plain, target: self, action: #selector(addNoteButtonTapped))
        
        navigationItem.rightBarButtonItems = [addNoteButton]
    }
    
    private func configureComponents(for book: Book) {
        let imagePath = viewModel.checkCoverImagePath()
        let provider = LocalFileImageDataProvider(fileURL: imagePath)
        let placeholder = BLDirectionView(symbolName: "photo", direction: nil)
        backdropImageView.kf.setImage(with: provider, placeholder: placeholder)
        coverImageView.kf.setImage(with: provider, placeholder: placeholder)
        titleLabel.text = book.title
        
        let authors = Array(book.authors).map { $0.name }.joined(separator: ", ")
        authorLabel.text = authors
        statusOfReadingLabel.setSelectedCase(to: book.statusOfReading)
        overviewTextView.text = book.overview
    }
    
    @objc private func addNoteButtonTapped() {
        let writeNoteViewController = WriteNoteViewController(book: viewModel.book.value) { [weak self] in
            self?.viewModel.fetchNotes()
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
}
