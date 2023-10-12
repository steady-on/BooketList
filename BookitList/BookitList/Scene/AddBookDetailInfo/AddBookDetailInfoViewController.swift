//
//  AddBookDetailInfoViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/10/05.
//

import UIKit
import Kingfisher

class AddBookDetailInfoViewController: BaseViewController {
    
    private let viewModel = AddBookDetailInfoViewModel()
    private let itemID: Int
    
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
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .secondaryAccent
        imageView.layer.shadowOffset = .init(width: 3, height: 3)
        imageView.layer.shadowColor = UIColor.systemGray.cgColor
        imageView.layer.shadowOpacity = 0.7
        return imageView
    }()
    
    private let formStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleTextField = BLTextField(placeholder: "제목(필수)")
    private let authorTextField = BLTextField(placeholder: "작가(필수)")
    private let publisherTextField = BLTextField(placeholder: "출판사(선택)")
    private let isbnTextField = BLTextField(placeholder: "ISBN(선택)")
    private let totalPagesTextField = BLTextField(placeholder: "전체 페이지 수(선택)")
    
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
    
    private let indicatorView = BLIndicatorView(direction: "책 정보를 불러오는 중 입니다.")
    
    init(itemID: Int) {
        self.itemID = itemID
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestBookDetailInfo(for: itemID)
        bindComponentWithObservable()
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        configureNavigationBar()
        
        let components = [scrollView, indicatorView]
        components.forEach { component in
            view.addSubview(component)
        }
        
        indicatorView.isHidden = true
        
        scrollView.addSubview(contentView)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let contentViewComponents = [backdropImageView, formView, coverImageView]
        contentViewComponents.forEach { contentView.addSubview($0) }
        
        
        let formViewComponents = [formStackView, overviewLabel, overviewTextView]
        formViewComponents.forEach { formView.addSubview($0) }
        
        let formStackViewComponents = [titleTextField, authorTextField, publisherTextField, isbnTextField, totalPagesTextField]
        formStackViewComponents.forEach { formStackView.addArrangedSubview($0) }
        
        publisherTextField.isUserInteractionEnabled = false
        isbnTextField.isUserInteractionEnabled = false
        totalPagesTextField.isUserInteractionEnabled = false
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        indicatorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    
    private func bindComponentWithObservable() {
        viewModel.selectedBook.bind { [weak self] itemDetail in
            let thumbnailURLString = itemDetail?.cover ?? ""
            let fullURLString = itemDetail?.subInfo.previewImgList?.first ?? thumbnailURLString
            
            let thumbnailURL = URL(string: thumbnailURLString)
            let fullURL = URL(string: fullURLString)
            
            self?.backdropImageView.kf.setImage(with: thumbnailURL)
            self?.coverImageView.kf.setImage(with: fullURL)
            self?.titleTextField.text = itemDetail?.title
            self?.authorTextField.text = itemDetail?.author
            self?.publisherTextField.text = itemDetail?.publisher
            self?.isbnTextField.text = itemDetail?.isbn13 ?? itemDetail?.isbn
            self?.totalPagesTextField.text = "\(itemDetail?.subInfo.itemPage ?? 0)"
            self?.overviewTextView.text = itemDetail?.description ?? itemDetail?.fullDescription
        }
        
        viewModel.isRequesting.bind { [weak self] bool in
            self?.indicatorView.isHidden = bool == false
        }
        
        viewModel.caution.bind { [weak self] caution in
            guard caution.isPresent else { return }
            self?.presentCautionAlert(title: caution.title, message: caution.message) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        titleTextField.addTarget(self, action: #selector(titleValueChanged), for: .editingChanged)
    }
}

extension AddBookDetailInfoViewController {
    @objc func titleValueChanged(_ sender: UITextField) {
        guard let title = sender.text else { return }
        viewModel.selectedBook.value?.title = title
    }
}

extension AddBookDetailInfoViewController {
    private func configureNavigationBar() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        
        let saveButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveBarButtonTapped))
        
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc private func saveBarButtonTapped() {
        viewModel.saveBookInfo(thumbnail: backdropImageView.image, full: coverImageView.image)
    }
}

