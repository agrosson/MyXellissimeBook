//
//  DetailBorrowedBookViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - Class DetailBorrowedBookViewController
/**
 This class defines the DetailBorrowedBookViewController
 */
class DetailBorrowedBookViewController: UIViewController {
    // MARK: - Properties
    /// Book borrowed
    var bookToDisplay = Book()
    /// Loan of current book displayed
    var currentLoan = LoanBook()
    /// Height for text
    let heightOfText: CGFloat = 20
    /// Current user Uid
    var  currentUid: String  {
        guard let uid = Auth.auth().currentUser?.uid else {return ""}
        return uid
    }
    /// Cover of the book
    let bookCoverImageView = CustomUI().imageView
    /// Title label for the book
    let titleLabel = CustomUI().label
    /// Author label for the book
    let authorLabel = CustomUI().label
    /// Container View for the book details
    let containerView = CustomUI().view
    /// SeparateView
    let separateView  = CustomUI().view
    /// Container data Loan details
    let containerDataView = CustomUI().view
    /// Reminder label
    let reminderLabel = CustomUI().label
    /// lender label
    let lenderLabel = CustomUI().label
    /// fromDate label
    let fromDateLabel = CustomUI().label
    /// toDate label
    let toDateLabel = CustomUI().label
    
     // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.addSubview(bookCoverImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(separateView)
        view.addSubview(containerDataView)
        containerDataView.addSubview(reminderLabel)
        containerDataView.addSubview(lenderLabel)
        containerDataView.addSubview(fromDateLabel)
        containerDataView.addSubview(toDateLabel)
        setupUIObjects()
        setupScreen()
        
    }
     // MARK: - Methods
    /**
     Function that sets up customUI objects
     */
    private func setupUIObjects(){
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        separateView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        reminderLabel.text = "You have borrowed this book from"
        reminderLabel.font = UIFont.systemFont(ofSize: 20)
        lenderLabel.text = "name and email"
        lenderLabel.font = UIFont.systemFont(ofSize: 20)
        fromDateLabel.text = "From date: " // calculate now
        fromDateLabel.font = UIFont.systemFont(ofSize: 20)
        toDateLabel.text = "To date: " // calculate now
        toDateLabel.font = UIFont.systemFont(ofSize: 20)
    }
    /**
     Function that sets up the screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        if let isbn = bookToDisplay.isbn {
            bookCoverImageView.loadingCoverImageUsingCacheWithisbnString(isbnString: isbn)
        }
        setupBookCoverImageView()
        setupTitleLabel()
        setupAuthorLabel()
        setupContainerView()
        setupSeparateView()
        setupContainerDataView()
        setupReminderLabel()
        setupBorrowerLabel()
        setupFromDateLabel()
        setupToDateLabel()
    }
}
