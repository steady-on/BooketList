//
//  AddBookDetailInfoViewController.swift
//  BookitList
//
//  Created by Roen White on 2023/10/05.
//

import UIKit

class AddBookDetailInfoViewController: BaseViewController {
    
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
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .secondaryAccent
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backdropImageView.image = UIImage.bookCover
        coverImageView.image = UIImage.bookCover
    }
    
    override func configureHiararchy() {
        super.configureHiararchy()
        
        title = "책 등록하기"
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        scrollView.contentInsetAdjustmentBehavior = .never
        
        let contentViewComponents = [backdropImageView, formView, coverImageView]
        contentViewComponents.forEach { contentView.addSubview($0) }
        
        
        let formViewComponents = [formStackView, overviewLabel, overviewTextView]
        formViewComponents.forEach { formView.addSubview($0) }
        
        let formStackViewComponents = [titleTextField, authorTextField, publisherTextField, isbnTextField, totalPagesTextField]
        formStackViewComponents.forEach { formStackView.addArrangedSubview($0) }
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
            make.top.equalTo(backdropImageView.snp.bottom).inset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        coverImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(coverImageView.snp.width).multipliedBy(1.5)
            make.bottom.equalTo(backdropImageView.snp.bottom).offset(4)
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
}

