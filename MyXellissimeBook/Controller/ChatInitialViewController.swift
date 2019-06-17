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
    /// Array of messages
    var messages = [Message]()
    /// Dictionary of last message by users
    var messagesDictionary = [String: Message]()
    
    let cellId = "cellId"
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action:  #selector(handelCompose))
        
     tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
     // observeMessages()
    observeUserMessages()
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    // this observes all messages send by a single user
    private func observeUserMessages(){
        // get the Id of the user
        guard let uid = Auth.auth().currentUser?.uid else {return}
        // get the ref of list of message for this uid
        let ref = Database.database().reference().child("user-messages").child(uid)
        // observe the node
        ref.observe(.childAdded, with: { (snapshot) in
            // get the key for the message
            let messageId = snapshot.key
            // get the reference of the message
            let messagesReference = Database.database().reference().child("messages").child(messageId)
            // observe the messages for this user
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
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
                
                // get the last message for toId
                self.messagesDictionary[toId] = message
                // and contruct an array with the values of the dictionary
                self.messages = Array(self.messagesDictionary.values)
                // sort the array of message
                self.messages.sort(by: { (message1, message2) -> Bool in
                    
                    guard let time1 = message1.timestamp else {return false}
                    guard let time2 = message2.timestamp else {return false}
                    return time1 > time2
                })
                DispatchQueue.main.async { self.tableView.reloadData() }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    // this obeserves all messages
    private func  observeMessages() {
       let ref = Database.database().reference().child(FirebaseUtilities.shared.messages)
        ref.observe(.childAdded, with: { snapshot in
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
            // get the last message for toId
            self.messagesDictionary[toId] = message
            // and contruct an array with the values of the dictionary
            self.messages = Array(self.messagesDictionary.values)
            // sort the array of message
            self.messages.sort(by: { (message1, message2) -> Bool in
                
                guard let time1 = message1.timestamp else {return false}
                guard let time2 = message2.timestamp else {return false}
                return time1 > time2
            })
            
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
        cell.messageUserCell = message
       
        return cell
    }
}
