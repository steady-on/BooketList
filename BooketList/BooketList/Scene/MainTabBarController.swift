//
//  MainTabBarController.swift
//  BookitList
//
//  Created by Roen White on 2023/09/28.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let readingRecordViewController = ReadingBoardViewController()
    private let bookShelfViewController = MyShelfViewController()
    private let noteViewController = MyNoteViewController()
    private let settingsViewController = SettingsViewController(style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBar()
    }
    
    func configureTabBar() {
        tabBar.tintColor = .accent

        readingRecordViewController.tabBarItem.image = UIImage(systemName: "house.fill")
        bookShelfViewController.tabBarItem.image = UIImage(systemName: "books.vertical.fill")
        noteViewController.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.fill")
        settingsViewController.tabBarItem.image = UIImage(systemName: "gearshape.fill")
        
        let viewControllers = [readingRecordViewController, bookShelfViewController, noteViewController, settingsViewController].map { viewController in
            UINavigationController(rootViewController: viewController)
        }
        
        setViewControllers(viewControllers, animated: true)
    }
}
