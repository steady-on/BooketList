//
//  BLStatusOfReadingLabel.swift
//  BookitList
//
//  Created by Roen White on 2023/10/25.
//

import UIKit

final class BLStatusOfReadingLabel: UIButton {
    
    private var statusOfReading: StatusOfReading
    
    private var baseBackgroundColor: UIColor {
        switch statusOfReading {
        case .notYet: return .blGray
        case .reading: return .blBlue
        case .finished: return .blGreen
        case .pause: return .blYellow
        case .stop: return .blRed
        }
    }
    
    init(for statusOfReading: StatusOfReading) {
        self.statusOfReading = statusOfReading
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configure()
    }
    
    func setStatus(for status: StatusOfReading) {
        self.statusOfReading = status
        configure()
    }
    
    private func configure() {        
        var config = UIButton.Configuration.filled()
        config.title = statusOfReading.label
        config.cornerStyle = .capsule
        config.buttonSize = .mini
        config.baseBackgroundColor = baseBackgroundColor
        configuration = config
    }
}
