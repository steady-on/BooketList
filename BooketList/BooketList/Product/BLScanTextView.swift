//
//  BLScanTextView.swift
//  BooketList
//
//  Created by Roen White on 12/20/23.
//

import UIKit

class BLScanTextView: UITextView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponder.captureTextFromCamera(_:)) {
            return true
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
