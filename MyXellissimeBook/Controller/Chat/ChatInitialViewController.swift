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

// MARK: - Class ChatInitialViewController
/**
 This class defines the ChatInitialViewController
 
 The controller will display the list of message sent and received by the user
 */
class ChatInitialViewController : UITableViewController {
    
     var rootRef = DatabaseReference()
    /// Array of all messages
    var messages = [Message]()
    /// Dictionary of last messages by users
    var messagesDictionary = [String: Message]()
    /// Id of cell of the tableView
    let cellId = "cellId"
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action:  #selector(handelCompose))
        fetchUserAndSetupNavBarTitle()
        // Registration of the reused cell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserAndSetupNavBarTitle()
    }
    /**
     function that observes all messages send by a single user
     */
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
                let chatPartnerId: String?
                
                if message.fromId == Auth.auth().currentUser?.uid {
                    chatPartnerId = message.toId
                } else {
                    chatPartnerId = message.fromId
                
                }
                print("here is the chatpertner \(String(describing: chatPartnerId))")
                guard let idToUse = chatPartnerId else {return}
               
                // get the last message for toId
                self.messagesDictionary[idToUse] = message
                // and contruct an array with the values of the dictionary
                self.messages = Array(self.messagesDictionary.values)
                // sort the array of messages by date
                self.messages.sort(by: { (message1, message2) -> Bool in
                    
                    guard let time1 = message1.timestamp else {return false}
                    guard let time2 = message2.timestamp else {return false}
                    return time1 > time2
                })
                DispatchQueue.main.async { self.tableView.reloadData() }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    

    func fetchUserAndSetupNavBarTitle(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child(FirebaseUtilities.shared.users).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                
                let user = User()
                
                guard let name = dictionary["name"] as? String else {return}
                guard let email = dictionary["email"] as? String else {return}
                guard let profileId = dictionary["profileId"] as? String else {return}
                
                user.name = name
                user.email = email
                user.profileId = profileId
                self.setupScreen(user: user)
            }
        }
    }
    
    /**
     Function that setup screen
     */
     func setupScreen(user: User){
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        observeUserMessages()
        
        self.navigationItem.titleView = setupNavBarWithUser(user: user)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
    // MARK: - Methods - override func tableView
    /*******************************************************
     override func tableView
     ********************************************************/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chatPartnerId = messages[indexPath.row].chatPartnerId() else {return}
        // first get the identifier of the parner user clicked
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
             guard let dictionary = snapshot.value as? [String : Any] else {return}
            // a user is created and in chatlogController a function is called because a user is set
            let user = User()
          
            guard let name = dictionary["name"] as? String else {return}
            guard let email =  dictionary["email"] as? String else {return}
            guard let profileId =  dictionary["profileId"] as? String else {return}
            user.name = name
            user.email = email
            user.profileId = profileId
            // Todo : check if  user.profileId should be chatPartnerId
            
            self.showChatControllerForUser(user: user)
          
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell of type UserCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        // Get the message from the Array
        let message = messages[indexPath.row]
        cell.message = message
       
        return cell
    }
}
