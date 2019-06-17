//
//  Message.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 16/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import Firebase


class Message: NSObject {
    var fromId: String?
    var text: String?
    var toId: String?
    var timestamp: Int?
    
    func chatPartnerId() -> String? {   
        return fromId == Auth.auth().currentUser?.uid ? toId: fromId
    }
}
