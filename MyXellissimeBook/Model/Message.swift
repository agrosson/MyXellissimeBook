//
//  Message.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 16/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Message class
/**
 This class defines the message attributes
 */
class Message: NSObject {
    var fromId: String?
    var text: String?
    var toId: String?
    var timestamp: Int?
    var messageImageUrl: String?
    var imageHeight: CGFloat?
    var imageWidth: CGFloat?
    
    // MARK: - Initializer
    init(dictionary: [String : Any]){
        super.init()
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as?  String
        toId = dictionary["toId"] as? String
        timestamp = dictionary["timestamp"] as? Int
        messageImageUrl = dictionary["messageImageUrl"] as?  String
        imageHeight = dictionary["imageHeight"] as?  CGFloat
        imageWidth = dictionary["imageWidth"] as?  CGFloat
        
        
        
    }
    // MARK: - Methods
    /**
     Function that defines the partner id of the current user
     - Returns: uid of partner as a String
     */
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId: fromId
    }
}
