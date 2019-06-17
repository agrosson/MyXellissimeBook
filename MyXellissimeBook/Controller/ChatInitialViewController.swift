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

class ChatInitialViewController : UITableViewController {
    
     var rootRef = DatabaseReference()
    /// Array of users
    var messages = [Message]()
    let cellId = "cellId"
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action:  #selector(handelCompose))
        
     tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
     observeMessages()
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    private func  observeMessages() {
        print("hello")
       let ref = Database.database().reference().child(FirebaseUtilities.shared.messages)
        ref.observe(.childAdded, with: { snapshot in
            print("hello 2")
            print(snapshot)
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let message = Message()
             guard let fromId = dictionary["fromId"] as? String else {return}
             guard let toId =  dictionary["toId"] as? String else {return}
             guard let text =  dictionary["text"] as? String else {return}
             guard let timestamp =  dictionary["timestamp"] as? Int else {return}
             message.fromId = fromId
             message.timestamp = timestamp
             message.toId = toId
             message.text = text
            
            self.messages.append(message)
            DispatchQueue.main.async { self.tableView.reloadData() }
            
        }, withCancel: nil)
       
        rootRef.removeAllObservers()
    }
    
    
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationItem.title = InitialViewController.titleName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatController)))
    }
    @objc func handelCompose(){
        let chatTableViewController = ChatTableViewController()
        chatTableViewController.chatInitial = self
        let navController = UINavigationController(rootViewController: chatTableViewController)
        present(navController, animated: true, completion: nil)
    }
    func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell of type UserCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        // Get the message from the Array
        let message = messages[indexPath.row]
        
        if let toId = message.toId {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapShot) in
                print(snapShot)
                
                if let dictionary = snapShot.value as? [String : Any] {
                    cell.textLabel?.text = dictionary["name"] as? String
                    if let profileImageURL = dictionary["profileImageURL"] as? String {
                       cell.profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileImageURL)
                    }
                }
            }, withCancel: nil)
        }
 
        
        cell.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = message.toId
        cell.detailTextLabel?.textColor = .white
        cell.detailTextLabel?.text = message.text
        
        return cell
    }
}
