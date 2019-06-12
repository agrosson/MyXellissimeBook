//
//  ViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// home Screen 
class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the left button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // check if user is already logged in
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }
    }
    // MARK: - Method  - Actions with objc functions
    /**
     Action that shows the loginviewcontroller when navigationItem.leftBarButtonItem pressed
     */
    @objc func handleLogout() {
        // Try to log out
        do {
            try Auth.auth().signOut()
             print("You are successfully logged out")
        }
        catch let logoutError {
            // todo: Alert to do
            print("error somewhere \(logoutError)")
        }
        // present LoginController
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}
