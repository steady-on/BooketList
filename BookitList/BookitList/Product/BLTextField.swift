//
//  BLTextField.swift
//  BookitList
//
//  Created by Roen White on 2023/10/08.
//

import UIKit

final class BLTextField: UITextField {

    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .placeholderText
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let underLinePadding: CGFloat = 8
    private let labelPadding: CGFloat = 4
    private let animationTimeInterval: TimeInterval = 0.25

    private var labelHeight: CGFloat {
        ceil(font?.pointSize ?? 0)
    }

    private var textFieldHeight: CGFloat {
        ceil(font?.lineHeight ?? 0)
    }

    private var isEmpty: Bool {
        text?.isEmpty ?? true
    }

    private var textInsets: UIEdgeInsets {
        UIEdgeInsets(top: labelHeight + labelPadding, left: 0, bottom: underLinePadding, right: 0)
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        self.placeholder = placeholder
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureHiararchy()
    }
    
    override func draw(_ rect: CGRect) {
        configureHiararchy()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        underLine.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
        updateLabel(animated: false)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: textInsets.top + textFieldHeight + textInsets.bottom)
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

    private func configureHiararchy() {
        borderStyle = .none
        placeholderLabel.text = placeholder

        let components = [placeholderLabel, underLine]
        components.forEach { component in
            addSubview(component)
        }

        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.placeholderText
        ])

        addTarget(self, action: #selector(handleEditing), for: .allEditingEvents)
    }

    @objc private func handleEditing() {
        updateLabel()
        updateBorder()
    }

    private func updateBorder() {
        var borderColor: UIColor {
            var color: UIColor
            
            color = isEmpty ? .placeholderText : .secondaryAccent
            if isFirstResponder { color = .highlight }
            
            return color
        }
        
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
