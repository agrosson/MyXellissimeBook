//
//  ViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

// home Screen 
class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the left button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    // Function that shows the loginviewcontroller when left button pressed
    @objc func handleLogout() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
}
