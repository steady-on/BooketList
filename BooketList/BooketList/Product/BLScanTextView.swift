//
//  BLScanTextView.swift
//  BooketList
//
//  Created by Roen White on 12/20/23.
//

import UIKit

class BLScanTextView: UITextView {

    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIAction.captureTextFromCamera(responder:identifier:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
