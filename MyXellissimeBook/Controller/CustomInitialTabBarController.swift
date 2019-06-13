//
//  CustomInitialTabBarController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

class CustomInitialTabBarController: UITabBarController {
   
    let initialViewController = UINavigationController(rootViewController: InitialViewController())
    let searchViewController = UINavigationController(rootViewController: SearchViewController())
    let tchatTableViewController = UINavigationController(rootViewController: TchatTableViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup custom VC
        setupTabBar()
        viewControllers = [initialViewController, searchViewController, tchatTableViewController ]
    }
    /**
     Function that setup tabBar
     */
    private func setupTabBar(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        initialViewController.tabBarItem.title = "My books"
        initialViewController.tabBarItem.image = UIImage(named: "books")
        searchViewController.tabBarItem.title = "Search"
        searchViewController.tabBarItem.image = UIImage(named: "search")
        tchatTableViewController.tabBarItem.title = "Tchat"
        // TODO : add an image
        // tchatTableViewController.tabBarItem.image = UIImage(named: "search")
    }
    
}
