//
//  UserTest.swift
//  MyXellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import MyXellissimeBook
@testable import FirebaseCore

class UserTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIfUserExists() {
        let user = User()
        XCTAssertNotNil(user)
    }
    
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
