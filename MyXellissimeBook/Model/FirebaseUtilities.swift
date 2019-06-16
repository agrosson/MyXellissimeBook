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

}

