//
//  CustomInitialTabBarController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Class CustomInitialTabBarController
/**
 This class defines the CustomInitialTabBarController : is defined as the windows.rootViewController in appDelegate
 */
class CustomInitialTabBarController: UITabBarController {
    
    /// instance of InitialViewController
    let initialViewController = UINavigationController(rootViewController: InitialViewController())
    /// instance of SearchViewController
    let searchViewController = UINavigationController(rootViewController: SearchViewController())
    /// instance of ChatTableViewController
    let chatInitialTableViewController = UINavigationController(rootViewController: ChatInitialViewController())
    /// /// instance of AllBooksViewController
    let allBooksViewController = UINavigationController(rootViewController: AllBooksViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup custom VC
        setupTabBar()
        viewControllers = [initialViewController, searchViewController, allBooksViewController, chatInitialTableViewController ]
    }
    /**
     Function that sets up tabBar
     */
    private func setupTabBar(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        initialViewController.tabBarItem.title = "Mes livres"
        initialViewController.tabBarItem.image = UIImage(named: "books")
        searchViewController.tabBarItem.title = "Rechercher"
        searchViewController.tabBarItem.image = UIImage(named: "search")
        allBooksViewController.tabBarItem.title = "Livres récents"
        allBooksViewController.tabBarItem.image = UIImage(named: "booksList")
        chatInitialTableViewController.tabBarItem.title = "Chat"
        chatInitialTableViewController.tabBarItem.image = UIImage(named: "message")
    }
}
