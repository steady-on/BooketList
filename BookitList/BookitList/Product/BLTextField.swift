//
//  BLTextField.swift
//  BookitList
//
//  Created by Roen White on 2023/10/08.
//

import UIKit

final class BLTextField: UITextField {

    private let underLine = UIView()
    private let placeholderLabel = UILabel()
    
    private let underLineOffset: CGFloat = 8
    private let animationTimeInterval: TimeInterval = 0.25

    private var labelHeight: CGFloat {
        ceil(font?.pointSize ?? 0)
    }

    private var textHeight: CGFloat {
        ceil(font?.lineHeight ?? 0)
    }

    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }

    private var textInsets: UIEdgeInsets {
        UIEdgeInsets(top: labelHeight, left: 0, bottom: underLineOffset, right: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        underLine.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        updateLabel(animated: false)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: textInsets.top + textHeight + textInsets.bottom)
    }

    override var placeholder: String? {
        didSet {
            placeholderLabel.text = placeholder
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.placeholderText
            ])
        }
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    private func setupUI() {
        borderStyle = .none

        underLine.backgroundColor = .placeholderText
        underLine.isUserInteractionEnabled = false
        addSubview(underLine)

        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.font = .preferredFont(forTextStyle: .caption1)
        placeholderLabel.text = placeholder
        placeholderLabel.isUserInteractionEnabled = false
        addSubview(placeholderLabel)

        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.secondaryAccent
        ])

        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }

    @objc
    private func handleEditing() {
        updateLabel()
        updateBorder()
    }

    private func updateBorder() {
        let borderColor: UIColor = isFirstResponder ? .highlight : .secondaryAccent
        UIView.animate(withDuration: animationTimeInterval) {
            self.underLine.backgroundColor = borderColor
        }
    }

    private func updateLabel(animated: Bool = true) {
        let alpha: CGFloat = isEmpty ? 0 : 1
        let y = isEmpty ? labelHeight * 0.5 : 0
        let labelFrame = CGRect(x: 0, y: y, width: bounds.width, height: labelHeight)

        guard animated else {
            placeholderLabel.frame = labelFrame
            placeholderLabel.alpha = alpha
            return
        }

        UIView.animate(withDuration: animationTimeInterval) {
            self.placeholderLabel.frame = labelFrame
            self.placeholderLabel.alpha = alpha
        }
    }
}
