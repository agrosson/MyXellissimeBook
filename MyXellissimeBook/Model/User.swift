//
//  User.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

// MARK: - User class
/**
 This class defines the user attributes
 */
class User : NSObject {
    // should we need this ?
    // var id : String?
    
    var name: String?
    /// Var email of the user
    var email: String?
    /// Var user UID which is also imageProfileName
    var profileId: String?
    /// fcmToken : Firebase Cloud Messaging token
    var fcmToken: String?
    
    // MARK: - Initializer
    override init(){}
}
