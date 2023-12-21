//
//  PageInputViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/02.
//

import UIKit

final class PageInputSheetViewController: BaseViewController {
    
    private var inputHandler: ((Int?) -> Void)?
    
    private let pageTextField = BLTextField(placeholder: "몇 페이지에 대한 노트인가요?")
    
    init(bookTitle: String, page: Int?, inputHandler: @escaping (Int?) -> Void) {
        super.init()
        
        self.title = bookTitle
        self.inputHandler = inputHandler
        
        if let page {
            self.pageTextField.text = "\(page)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
        inputHandler = nil
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        pageTextField.delegate = self
        pageTextField.keyboardType = .numberPad
        pageTextField.becomeFirstResponder()
        
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
    
    override func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "입력", style: .done, target: self, action: #selector(inputButtonTapped))
    }
    
    @objc private func inputButtonTapped() {
        let page = Int(pageTextField.text ?? "")
        inputHandler?(page)
        dismiss(animated: true)
    }
}

extension PageInputSheetViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard string.isEmpty || Int(string) != nil else { return false }
        
        return true
    }
}
