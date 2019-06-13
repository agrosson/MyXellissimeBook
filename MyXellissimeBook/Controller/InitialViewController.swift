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
class InitialViewController: UITableViewController {
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create the left button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        // Setup screen
         setupScreen()
        checkIfUserIsAlreadyLoggedIn()
    }
    
    fileprivate func checkIfUserIsAlreadyLoggedIn() {
        // check if user is already logged in
        
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String : Any] {
                    self.navigationItem.title = dictionary["name"] as? String
                    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                }
               print(snapshot)
            }
            
        }
    }
    
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
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
