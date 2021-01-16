//
//  FYPTabBarController.swift
//  NewFYP
//
//  Created by Amer Abboud on 1/10/21.
//  Copyright © 2021 Amer Abboud. All rights reserved.
//

import UIKit

class FYPTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemBlue
        viewControllers = [createLibraryNC(), createAddNC(), createSettingsNC()]
    }
    
    func createLibraryNC() -> UINavigationController {
        let libraryVC = LibraryTableVC()
        libraryVC.title = "Library"
        libraryVC.tabBarItem = UITabBarItem(title: "Library", image: Images.libraryBarLogo, tag: 0)
        return UINavigationController(rootViewController: libraryVC)
    }
    
    func createAddNC() -> UINavigationController  {
        let yourBooksVC = YourBooksVC()
        yourBooksVC.title = "Your books"
        yourBooksVC.tabBarItem = UITabBarItem(title: "Add", image: Images.addBarLogo, tag: 1)
        return UINavigationController(rootViewController: yourBooksVC)
    }
    
    func createSettingsNC() -> UINavigationController {
        let settingsVC = SettingsVC()
        settingsVC.title = "Settings"
        settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: Images.settingsBarLogo, tag: 2)
        return UINavigationController(rootViewController: settingsVC)
    }
}
