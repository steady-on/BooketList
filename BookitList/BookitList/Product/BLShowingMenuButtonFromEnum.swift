//
//  BLShowingMenuButtonFromEnum.swift
//  BookitList
//
//  Created by Roen White on 2023/11/01.
//

import UIKit

class BLShowingMenuButtonFromEnum<T: ShowingMenuButton>: UIButton {
    private var selectedCase: T
    private let actionHandler: (T) -> Void
    
    init(selectedCase: T, actionHandler: @escaping (T) -> Void) {
        self.selectedCase = selectedCase
        self.actionHandler = actionHandler
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        configure()
        configureMenu()
    }
    
    override func updateConfiguration() {
        super.updateConfiguration()
        
        configuration?.baseBackgroundColor = selectedCase.color
    }
    
    private func configure() {
        showsMenuAsPrimaryAction = true
        changesSelectionAsPrimaryAction = true
        
        let symbolConfig = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .caption1))
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.buttonSize = .mini
        config.image = UIImage(systemName: "chevron.down", withConfiguration: symbolConfig)
        config.imagePlacement = .trailing
        config.imagePadding = 8
        configuration = config
    }
    
    private func configureMenu() {
        let actions: [UIAction] = T.allCases.map { someCase in
            let action = UIAction(title: someCase.title, image: UIImage(systemName: someCase.iconImageName)) { _ in
                self.selectedCase = someCase
                self.actionHandler(someCase)
            }
            
            if someCase == selectedCase {
                action.state = .on
            }
            
            return action
        }
        
        let menu = UIMenu(options: .singleSelection, children: actions)
        
        self.menu = menu
    }
    
    func setSelectedCase(to selectedCase: T) {
        self.selectedCase = selectedCase
        configureMenu()
    }
}
