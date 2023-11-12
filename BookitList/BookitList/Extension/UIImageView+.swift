//
//  UIImageView+.swift
//  BookitList
//
//  Created by Roen White on 2023/10/05.
//

import UIKit

extension UIImageView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    
    func darkfilterEffect() {
        let darkFilterView = UIView()
        darkFilterView.backgroundColor = .reverseBackground.withAlphaComponent(0.4)
        darkFilterView.frame = bounds
        darkFilterView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(darkFilterView)
    }
}
