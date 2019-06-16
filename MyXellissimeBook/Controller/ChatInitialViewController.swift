//
//  ChatInitialViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 15/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatInitialViewController : UIViewController {
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action:  #selector(handelCompose))
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationItem.title = InitialViewController.titleName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    @objc func handelCompose(){
        let chatTableViewController = ChatTableViewController()
        chatTableViewController.chatInitial = self
        let navController = UINavigationController(rootViewController: chatTableViewController)
        present(navController, animated: true, completion: nil)
    }
    @objc func showChatController(){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}
