//
//  FirebaseUtilities.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUtilities {
    
    static var shared = FirebaseUtilities()
    private init(){}
    
    /*******************************************************
     These variables used in Firebase to avoid misspelling
     ********************************************************/
    
    let users = "users"
    let profileImage = "profileImage"
    let messages = "messages"
    let user_messages = "user-messages"
    let user_books = "user-books"
    
    
    var name = ""
    
    static func getUserName() -> String? {
        guard let uid = Auth.auth().currentUser?.uid else {return "no name"}
        self.shared.name = "33"
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) {  (snapshot) in
            self.shared.name = ""
            if let dictionary = snapshot.value as? [String : Any] {
                self.shared.name = (dictionary["name"] as? String)!
                print("ici avec \(self.shared.name)")
            }
        }
      return self.shared.name
    }
    
    /*******************************************************
     This function saves a text as a message in firebase
     ********************************************************/
    static func saveMessage(text: String, fromId : String, toUser: User) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.messages)
        /// unique reference for the message
        let childRef = ref.childByAutoId()
        /// get the recipient Id
        guard let toId = toUser.profileId else {return}
        let timestamp = Int(NSDate().timeIntervalSince1970)
        // Create a dictionary of values to save
        let values = ["text" : text, "toId" : toId, "fromId" : fromId, "timestamp" : timestamp] as [String : Any]
        // this block to save the message and then also make a reference and store the reference of message in antoher node
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            // create a new node fromId user
            let userMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(fromId)
            // get the key of the message
            let messageId = childRef.key
            // store the  message here for the fromId user
            userMessageRef.updateChildValues([messageId : 1])
            // create a new node toId user
            let recipientUserMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(toId)
            // store the key message here for the toId user
            recipientUserMessageRef.updateChildValues([messageId : 1])
        }
    }
}

