//
//  LoanBookTestCase.swift
//  MyXellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 20/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import MyXellissimeBook

class LoanBookTestCase: XCTestCase {

    func testIfLoanBookExists() {
        let loanBook = LoanBook()
        XCTAssertNotNil(loanBook)
    }

}
