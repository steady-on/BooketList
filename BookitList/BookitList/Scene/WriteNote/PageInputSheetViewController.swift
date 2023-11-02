//
//  PageInputViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/02.
//

import UIKit

class PageInputSheetViewController: BaseViewController {
    
    private let viewModel: PageInputSheetViewModel
    
    private let directionLabel: UILabel = {
        let label = UILabel()
        label.text = "몇 페이지에 대한 노트인가요?"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .reverseBackground
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let pageTextField = BLTextField(placeholder: "몇 페이지에 대한 노트인가요?")
    private let inputHandler: (Int?) -> Void
    
    init(bookTitle: String, page: Int?, inputHandler: @escaping (Int?) -> Void) {
        self.viewModel = PageInputSheetViewModel(page: page)
        self.inputHandler = inputHandler
        super.init()
        self.title = bookTitle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        pageTextField.delegate = self
        
        configureNavigationBar()
        modalTransitionStyle = .partialCurl
        sheetPresentationController?.detents = [.medium()]
        sheetPresentationController?.prefersGrabberVisible = true
        
        view.addSubview(pageTextField)
    }
    
    override func setConstraints() {
        pageTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func bindComponentWithObservable() {
        viewModel.page.bind { [weak self] page in
            guard let page else { return }
            self?.pageTextField.text = "\(page)"
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "입력", style: .done, target: self, action: #selector(inputButtonTapped))
    }
    
    @objc private func inputButtonTapped() {
        let page = Int(pageTextField.text ?? "")
        dismiss(animated: true) {
            self.inputHandler(page)
        }
    }
}

extension PageInputSheetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.isEmpty || Int(string) != nil else { return false }
        
        return true
    }
}
