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
    /// Var to track if user has accepted conditions
    var hasAcceptedConditions: String?
    /// Date of user registrations
    var timestamp: Int?
    /// Date of user last logout
    var timestampLastLogout: Int?
    /// Date of user last login
    var timestampLastLogIn: Int?
    
    
    // MARK: - Initializer
    override init(){}
}
