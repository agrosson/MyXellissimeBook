//
//  LoanBook.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 19/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import Firebase


class LoanBook: NSObject {
    /// Reference of the loan
    var uniqueLoanBookId: String?
    /// The book loaned
    var bookId: String?
    /// Owner of the book
    var fromUser: String?
    /// User who borrows the book
    var toUser: String?
    /// Loan start date
    var loanStartDate: Int?
    /// Expected end date of the loan
    var expectedEndDateOfLoan: Int?
    /// Effective end date of loan : loan closed
    var effectiveEndDateOfLoan: Int?
}
