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
class User {
    /// Var name of the user
    var name: String
    /// Var email of the user
    var email: String

    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
