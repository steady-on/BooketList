//
//  EditBookDetailInfoViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/11/10.
//

import UIKit
import Kingfisher

final class EditBookDetailInfoViewController: BaseViewController {
    
    private let viewModel: EditBookDetailInfoViewModel
    
    init(for book: Book) {
        self.viewModel = EditBookDetailInfoViewModel(book: book)
        super.init()
    }

    private let scrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
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
    
    private let formView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.directionalLayoutMargins = .init(top: 16, leading: 20, bottom: 16, trailing: 20)
        return view
    }()
    
    private let coverImageView = {
        let imageView = UIImageView()
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondaryAccent
        imageView.backgroundColor = .systemGray4
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let formStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleTextField = BLTextField(placeholder: "제목")
    private let originalTitleTextField = BLTextField(placeholder: "원제")
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "도서에 등록할 작가를 선택해주세요."
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .body)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var selectAuthorView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
        
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.text = "책 소개"
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.backgroundColor = .systemFill
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImageView()
        setCoverImageViewConstraints(for: viewModel.book.coverImageSize)
        arrangeArtistButtons(for: viewModel.authors.map { $0.author })
    }

    override func configureHiararchy() {
        super.configureHiararchy()
        
        overviewTextView.delegate = self
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let contentViewComponents = [backdropImageView, formView, coverImageView]
        contentViewComponents.forEach { contentView.addSubview($0) }
        
        
        let formViewComponents = [formStackView, overviewLabel, overviewTextView]
        formViewComponents.forEach { formView.addSubview($0) }
        
        let formStackViewComponents = [titleTextField, originalTitleTextField, selectAuthorView]
        formStackViewComponents.forEach { formStackView.addArrangedSubview($0) }
        
        selectAuthorView.addArrangedSubview(authorLabel)
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.contentLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(backdropImageView.snp.width).multipliedBy(0.8)
        }
        
        formView.snp.makeConstraints { make in
            make.top.equalTo(backdropImageView.snp.bottom).inset(12)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.3)
            make.bottom.equalTo(formView.snp.top).inset(8)
        }
        
        formStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalTo(formView.layoutMarginsGuide)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(formStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(formView.layoutMarginsGuide)
        }

        overviewTextView.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(formView.layoutMarginsGuide)
            make.bottom.equalTo(formView.layoutMarginsGuide)
        }
    }
    
    override func configureNavigationBar() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        
        let saveButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveBarButtonTapped))
        let beforeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(beforeButtonTapped))
        
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = beforeButton
    }
    
    override func bindComponentWithObservable() {
        viewModel.title.bind { [weak self] title in
            self?.titleTextField.text = title
        }
        
        viewModel.originalTitle.bind { [weak self] originalTitle in
            self?.originalTitleTextField.text = originalTitle
        }
        
        viewModel.overviewText.bind { [weak self] overview in
            self?.overviewTextView.text = overview
        }
        
        viewModel.caution.bind { [weak self] caution in
            guard caution.isPresent else { return }

            self?.presentCautionAlert(title: caution.title, message: caution.message)
        }
        
        titleTextField.addTarget(self, action: #selector(titleValueChanged), for: .editingChanged)
        originalTitleTextField.addTarget(self, action: #selector(originalTitleValueChanged), for: .editingChanged)
    }
    
    @objc func titleValueChanged(_ sender: UITextField) {
        guard let value = sender.text else { return }
        viewModel.title.value = value
    }
    
    @objc func originalTitleValueChanged(_ sender: UITextField) {
        viewModel.originalTitle.value = sender.text
    }
    
    private func configureImageView() {
        let imagePath = viewModel.checkCoverImagePath()
        let provider = LocalFileImageDataProvider(fileURL: imagePath)
        let placeholder = BLDirectionView(symbolName: "photo", direction: nil)
        backdropImageView.kf.setImage(with: provider, placeholder: placeholder)
        coverImageView.kf.setImage(with: provider, placeholder: placeholder)
    }
    
    private func setCoverImageViewConstraints(for size: ImageSize?) {
        guard let size else { return }
        
        coverImageView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(size.height / size.width)
            make.bottom.equalTo(formView.snp.top).inset(8)
        }
    }
    
    private func arrangeArtistButtons(for authors: [Author]) {
        zip(authors, 1...).forEach { (author, tagValue) in
            let button = makeButton(for: author, tagValue: tagValue)
            button.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            selectAuthorView.addArrangedSubview(button)
        }
    }
    
    private func makeButton(for author: Author, tagValue: Int) -> UIButton {
        let button = UIButton()
        button.contentHorizontalAlignment = .leading
        
        var config = UIButton.Configuration.tinted()
        config.title = author.name
        config.subtitle = author.typeDescriptions[viewModel.book._id.stringValue]
        config.titleAlignment = .leading
        
        button.configuration = config
        button.tag = tagValue
        button.isSelected = author.isTracking
        return button
    }
    
    @objc private func buttonSelected(_ sender: UIButton) {
        sender.isSelected.toggle()
        viewModel.toggleIsTrackingAuthor(tag: sender.tag)
    }
    
    @objc private func saveBarButtonTapped() {
        guard let titleValue = titleTextField.text, titleValue.isEmpty == false else {
            viewModel.caution.value = Caution(isPresent: true, title: "책 제목을 입력해주세요.", message: "책 제목은 반드시 입력되어야 합니다. 제목을 입력해주세요.", willDismiss: false)
            titleTextField.becomeFirstResponder()
            return
        }
        
        viewModel.saveUpdatedInfo()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func beforeButtonTapped() {
        let alert = UIAlertController(title: "앗, 잠시만요!", message: "지금까지 작성한 내용이 모두 사라집니다. 정말 창을 닫을까요?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "아니요!", style: .cancel)
        let okay = UIAlertAction(title: "창 닫기", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(cancel)
        alert.addAction(okay)
        
        present(alert, animated: true)
    }
}

extension EditBookDetailInfoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.overviewText.value = textView.text
    }
}
