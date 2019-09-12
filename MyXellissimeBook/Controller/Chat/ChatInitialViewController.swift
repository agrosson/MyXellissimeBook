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
    /// A timer to fix reload table to many times
    var timerChat: Timer?
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action:  #selector(handelCompose))
        fetchUserAndSetupNavBarTitle()
        // Registration of the reused cell
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsMultipleSelectionDuringEditing = true
        observeAllMessages()
    }
   
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserAndSetupNavBarTitle()
        UIApplication.shared.applicationIconBadgeNumber = 0
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
            // get the key for the userId
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
            // get the key for the message
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)

            }, withCancel: nil)
        //    return
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with:  { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadData()
        }, withCancel: nil)
    }
    
    /**
     function that fetches message
     - Parameter messageId: the unique identifier (String) of the message in Firebase
     */
    private func fetchMessageWithMessageId(messageId: String) {
        //get the reference of the message
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        // observe the messages for this user
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let message = Message(dictionary: dictionary)
            let chatPartnerId: String?
            if message.fromId == Auth.auth().currentUser?.uid {
                chatPartnerId = message.toId
            } else {
                chatPartnerId = message.fromId
            }
            guard let idToUse = chatPartnerId else {return}
            // get the last message for toId
            self.messagesDictionary[idToUse] = message
            // To avoid reload data too many times when messages have not be updated
            self.attemptReloadData()
        }, withCancel: nil)
    }
    
    
    /**
     function that attempts to reload data
     */
    private func attemptReloadData(){
        self.timerChat?.invalidate()
        self.timerChat = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handlerReloadTable), userInfo: nil, repeats: false)
    }
    
    /**
     function that reloads data
     */
    @objc func handlerReloadTable(){
        // contruct an array with the values of the dictionary
        self.messages = Array(self.messagesDictionary.values)
        // sort the array of messages by date
        self.messages.sort(by: { (message1, message2) -> Bool in
            
            guard let time1 = message1.timestamp else {return false}
            guard let time2 = message2.timestamp else {return false}
            return time1 > time2
        })
        DispatchQueue.main.async {
            self.tableView.reloadData() }
    }
    
    /**
     function that sets us the navBar
     */
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
     Function that sets up screen
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
    
    /**
     Function that presents chatTableViewController
     */
    @objc func handelCompose(){
        let chatTableViewController = ChatTableViewController()
        chatTableViewController.chatInitial = self
        let navController = UINavigationController(rootViewController: chatTableViewController)
        present(navController, animated: true, completion: nil)
    }
    /**
     Function that presents chatLogController
     */
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let message = self.messages[indexPath.row]
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let toId = message.chatPartnerId() else {return}
        Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(uid).child(toId).removeValue { (error, ref) in
            if error != nil {
                print("Failed to remove  message:", error as Any)
                return
            }
            self.messagesDictionary.removeValue(forKey: toId)
            self.attemptReloadData()
        }
    
        
    }
    
    
    /**
     function that observes all messages to identify messages posted more than 4 weeks ago
     */
    private func observeAllMessages() {
        // Search message
        let ref = Database.database().reference().child(FirebaseUtilities.shared.messages)
        // observe each node
        ref.observe(.childAdded, with: { (snapshot) in
            // get the key for the message
            let messageId = snapshot.key
            // then go to the message itself
            let booksReference = Database.database().reference().child(FirebaseUtilities.shared.messages).child(messageId)
            // observe the message, get info from it
            booksReference.observeSingleEvent(of: .value, with: { (snapshot) in
                // the snapshot result is a dictionary
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                // get the value your need
                guard let timeStamp = dictionary["timestamp"] as? Int else {return}
                guard let toId = dictionary["toId"] as? String else {return}
                guard let fromId  = dictionary["fromId"] as? String else {return}
                // Get current timestamp
                let now = Int(NSDate().timeIntervalSince1970)
                // a day is 864000 seconds / a week is 6048000 seconds / 4 weeks are 2419200 seconds
                // if timeStamp is more than 4 weeks, remove message from Firebase
                if now > timeStamp + 2419200 {
                    FirebaseUtilities.deleteMessage(with: messageId, fromId: fromId, toId: toId)
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
}
