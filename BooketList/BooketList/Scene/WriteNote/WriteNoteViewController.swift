//
//  WriteNoteViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/01.
//

import UIKit

class WriteNoteViewController: BaseViewController {
    
    private let viewModel: WriteNoteViewModel
    private let dismissHandler: (() -> Void)?
    
    init(book: Book, dismissHandler: (() -> Void)? = nil) {
        self.viewModel = WriteNoteViewModel(book: book)
        self.dismissHandler = dismissHandler
        super.init()
    }
    
    private lazy var noteTypeButton: BLShowingMenuButtonFromEnum<NoteType> = {
        BLShowingMenuButtonFromEnum(selectedCase: .quote) { [weak self] selectedCase in
            self?.viewModel.changeNoteType(to: selectedCase)
        }
    }()
    
    private let scanTextButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "text.viewfinder")
        config.buttonSize = .mini
        config.cornerStyle = .capsule
        button.configuration = config
        return button
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
    
    private lazy var saveBarButton: UIBarButtonItem = {
        UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        view.directionalLayoutMargins = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        contentTextView.delegate = self
        
        let components = [noteTypeButton, pageButton, scanTextButton, contentTextView]
        components.forEach { component in
            view.addSubview(component)
        }
        
        pageButton.addTarget(self, action: #selector(pageButtonTapped), for: .touchUpInside)
        scanTextButton.addAction(UIAction.captureTextFromCamera(responder: contentTextView, identifier: nil), for: .touchUpInside)
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
        
        scanTextButton.snp.makeConstraints { make in
            make.centerY.equalTo(noteTypeButton)
            make.trailing.equalTo(pageButton.snp.leading).offset(-8)
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
            self?.saveBarButton.isEnabled = content.isEmpty == false
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonTapped))
        navigationItem.rightBarButtonItem = saveBarButton
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
        dismiss(animated: true) { [weak self] in
            self?.dismissHandler?()
        }
    }
    
    @objc private func pageButtonTapped() {
        let pageInputAlert = UIAlertController(title: "몇 페이지에 대한 노트인가요?", message: nil, preferredStyle: .alert)
        pageInputAlert.addTextField { [weak self] textField in
            if let page = self?.viewModel.page.value {
                textField.text = "\(page)"
            }
            textField.keyboardType = .numberPad
            textField.delegate = self
            textField.clearButtonMode = .always
            textField.placeholder = "숫자만 입력 가능"
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let input = UIAlertAction(title: "입력", style: .default) { [weak self] _ in
            let inputValue = pageInputAlert.textFields?.first?.text ?? ""
            let page = Int(inputValue)
            self?.viewModel.page.value = page
        }
        
        pageInputAlert.addAction(cancel)
        pageInputAlert.addAction(input)
        
        present(pageInputAlert, animated: true)
    }
    
    private func presentCloseAlert() {
        let alert = UIAlertController(title: "앗, 잠시만요!", message: "지금까지 작성한 내용이 모두 사라집니다. 정말 창을 닫을까요?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "아니요!", style: .cancel)
        let okay = UIAlertAction(title: "창 닫기", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
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

extension WriteNoteViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.isEmpty || Int(string) != nil else { return false }
        
        return true
    }
}
