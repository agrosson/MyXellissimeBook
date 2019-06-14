//
//  AddBookViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 14/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

class AddBookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissCurrentView))
        setupScreen()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super .viewWillAppear(animated)
        setupScreen()
    }
    
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                self.navigationItem.title = dictionary["name"] as? String
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
        }
    }
    
    @objc private func dismissCurrentView(){
        self.dismiss(animated: true, completion: nil)
    }
}
