//
//  MessageTestCase.swift
//  MyXellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 20/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import MyXellissimeBook
import Firebase

class MessageTestCase: XCTestCase {
    
    func testIfMeassageExists() {
        let dictionaryTest = ["text" : 2,
                              "fromId" : "this a id from user",
                              "gg":"gg"] as [String : Any]
        let message = Message(dictionary: dictionaryTest)
        XCTAssertNotNil(message)
    }
}
