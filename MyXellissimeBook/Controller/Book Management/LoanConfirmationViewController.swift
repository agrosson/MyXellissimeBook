//
//  LoanConfirmationViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 23/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import  Firebase

// MARK: - Class LoanConfirmationViewController
/**
 This class enables to confirm and save a book loan
 */
class LoanConfirmationViewController: UIViewController {
    // MARK: - Properties
    /// The book to lend
    var bookToLend = Book()
    /// The borrower as user
    var userBorrower = User()
    /// Starting Date of the Loan
    var fromDate: Int {
        let date = Int(NSDate().timeIntervalSince1970)
        return date
    }
    /// Expected date for date of loan
    // test le 25092019 pour les fonctions de firebase deadline 1h
    // a day is 86 400 seconds / a week is 604 800 seconds / 3 weeks are 1 814 400 seconds /4 weeks are 2 419 200 seconds
    // Test le 08 11 2019 -> 3 heures pour les notification cloud functions
    var toDate: Int {
        let toDate = Int(NSDate().timeIntervalSince1970)+604800
        return toDate
    }
    /// height of text in container data view
    let heightOfText: CGFloat = 20
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
    /// borrower label
    let borrowerLabel = CustomUI().label
    /// fromDate label
    let fromDateLabel = CustomUI().label
    /// toDate label
    let toDateLabel = CustomUI().label
    /// Confirmation button for loan
    lazy var confirmLoanButton = CustomUI().button
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.addSubview(bookCoverImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(separateView)
        view.addSubview(containerDataView)
        containerDataView.addSubview(reminderLabel)
        containerDataView.addSubview(borrowerLabel)
        containerDataView.addSubview(fromDateLabel)
        containerDataView.addSubview(toDateLabel)
        containerDataView.addSubview(confirmLoanButton)
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
        reminderLabel.text = "Vous voulez prêter ce livre à"
        reminderLabel.font = UIFont.systemFont(ofSize: 20)
        borrowerLabel.text = "nom et email"
        borrowerLabel.font = UIFont.systemFont(ofSize: 20)
        fromDateLabel.text = "Du: " // calculate now
        fromDateLabel.font = UIFont.systemFont(ofSize: 20)
        toDateLabel.text = "Au: " // calculate now
        toDateLabel.font = UIFont.systemFont(ofSize: 20)
        confirmLoanButton.setTitle("Confirmer", for: .normal)
        confirmLoanButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        confirmLoanButton.layer.cornerRadius = 15
        confirmLoanButton.addTarget(self, action: #selector(confirmLoan), for: .touchUpInside)
    }
    /**
     Function that sets up the screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        if let isbn = bookToLend.isbn {
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
        setupConfirmLoanButton()
    }
    /**
        Function that checks if user has more than 5 loans
    */
    private func testIfUserHasMoreThan5Loans(userBorrower: User){
        print("This function checks number of loans for userBorrower")
        // Count current loans
        
    }
    
    // MARK: - Methods  - Actions with objc functions
    /**
     Function that launches registration of the loan
     */
    @objc func confirmLoan() {
        testIfUserHasMoreThan5Loans(userBorrower: userBorrower)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseUtilities.saveLoan(bookToLend: bookToLend, fromId: uid, toUser: userBorrower, loanStartDate: fromDate, expectedEndDateOfLoan: toDate)
        dismiss(animated: true, completion: nil)
    }
}
