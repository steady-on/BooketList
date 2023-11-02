//
//  WriteNoteViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/01.
//

import UIKit

class WriteNoteViewController: BaseViewController {
    
    private let viewModel: WriteNoteViewModel
    
    private lazy var noteTypeButton: BLShowingMenuButtonFromEnum<NoteType> = {
        BLShowingMenuButtonFromEnum(selectedCase: .quote) { [weak self] selectedCase in
            self?.viewModel.changeNoteType(to: selectedCase)
        }
    }()
    
    private let pageButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.title = "페이지"
        config.baseForegroundColor = .secondaryLabel
        config.buttonSize = .mini
        config.cornerStyle = .capsule
        config.background.strokeColor = .secondaryLabel
        config.background.strokeWidth = 1
        button.configuration = config
        return button
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.secondaryLabel.cgColor
        textView.layer.borderWidth = 1
        textView.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        textView.becomeFirstResponder()
        textView.keyboardDismissMode = .onDrag
        return textView
    }()
    
    init(book: Book) {
        self.viewModel = WriteNoteViewModel(book: book)
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        view.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        contentTextView.delegate = self
        
        let components = [noteTypeButton, pageButton, contentTextView]
        components.forEach { component in
            view.addSubview(component)
        }
        
        pageButton.addTarget(self, action: #selector(pageButtonTapped), for: .touchUpInside)
    }
    
    override func setConstraints() {
        noteTypeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.directionalLayoutMargins)
        }
        
        pageButton.snp.makeConstraints { make in
            make.centerY.equalTo(noteTypeButton)
            make.trailing.equalTo(view.directionalLayoutMargins)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(noteTypeButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(view.directionalLayoutMargins)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-16)
        }
    }
    
    override func bindComponentWithObservable() {
        viewModel.book.bind { [weak self] book in
            self?.title = book.title
        }
        
        viewModel.page.bind { [weak self] page in
            let buttonTitle = page == nil ? "페이지" : "P. \(page!)"
            self?.pageButton.setTitle(buttonTitle, for: .normal)
        }
        
        viewModel.content.bind { [weak self] content in
            self?.navigationItem.rightBarButtonItem?.isEnabled = content.isEmpty == false
        }
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonTapped))
    }
    
    @objc private func closeButtonTapped() {
        guard viewModel.content.value.isEmpty == false else {
            dismiss(animated: true)
            return
        }
        
        presentCloseAlert()
    }
    
    @objc private func saveButtonTapped() {
        viewModel.saveNote()
        dismiss(animated: true)
    }
    
    @objc private func pageButtonTapped() {
        let pageInputViewController = PageInputSheetViewController(bookTitle: viewModel.book.value.title, page: viewModel.page.value) { page in
            self.viewModel.page.value = page
        }
        let navigationController = UINavigationController(rootViewController: pageInputViewController)
        present(navigationController, animated: true)
    }
    
    private func presentCloseAlert() {
        let alert = UIAlertController(title: "앗, 잠시만요!", message: "지금까지 작성한 내용이 모두 사라집니다. 정말 창을 닫을까요?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "아니요!", style: .cancel)
        let okay = UIAlertAction(title: "창 닫기", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}

extension WriteNoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.content.value = textView.text
    }
}
