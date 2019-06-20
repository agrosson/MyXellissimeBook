//
//  UtilitiesTestCase.swift
//  MyXellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 20/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import MyXellissimeBook

class UtilitiesTestCase: XCTestCase {

    // test removeFirstAndLastAndDoubleWhitespace() success
    func testGivenAStringWhenWhiteSpaceThenRemoveIt() {
        var testString = "  a  string  "
        let cleanString = "a string"
        testString.removeFirstAndLastAndDoubleWhitespace()
        XCTAssert(cleanString == testString)
    }
    //
    func testGivenAStringWhenWhiteSpaceThenRemoveItWithError() {
        var testString = "  a  string  "
        let cleanString = "a  string"
        testString.removeFirstAndLastAndDoubleWhitespace()
        XCTAssert(cleanString != testString)
    }
   

}
