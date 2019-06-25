//
//  DetailLentBookViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 22/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

class DetailLentBookViewController: UIViewController {

    /// Book to be lent
    var bookToDisplay: Book?
    /// Height for labels
    let loanDetailsLabelHeight:CGFloat = {
        if screenHeight > 700 {
            return 60
        } else if screenHeight > 600 {
            return 40}
        return 35 }()
    /// Height for text
    let loanTextSize: CGFloat = 22
    /// inset between labels
    let insetBetweenLabels: CGFloat = {
        if screenHeight > 700 {
            return 20
        }
        return 10 }()
    /// Current user Uid
    var  currentUid: String  {
        guard let uid = Auth.auth().currentUser?.uid else {return ""}
        return uid
    }
    var currentLoanId: String?
    
    /*******************************************************
     UI variables: Start
     ********************************************************/
    /// Cover of the book
    let bookCoverImageView = CustomUI().imageView
    /// Title label for the book
    let titleLabel = CustomUI().label
    /// Author label for the book
    let authorLabel = CustomUI().label
    /// Editor label for the book
    let editorLabel = CustomUI().label
    /// Container View for Loan details
    let containerView = CustomUI().view
    /// Borrower label for the lent book
    let borrowerLabel = CustomUI().label
    /// Starting date for the lent
    let startingDateOfLoanLabel = CustomUI().label
    /// Expected end date for the lent
    let expectedEndDateOfLoanLabel = CustomUI().label
    /// Close loan Button
    lazy var closeLoanButton = CustomUI().button
 

    /*******************************************************
     UI variables: End
     ********************************************************/
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bookCoverImageView)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(editorLabel)
        view.addSubview(containerView)
        containerView.addSubview(borrowerLabel)
        containerView.addSubview(startingDateOfLoanLabel)
        containerView.addSubview(expectedEndDateOfLoanLabel)
        containerView.addSubview(closeLoanButton)
        setupUIObjects()
        setupScreen()
        getLoans()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
        getLoans()
    }
    /**
     Function that sets up customUI objects
     */
    private func setupUIObjects(){
        titleLabel.textAlignment = NSTextAlignment.center
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        authorLabel.textAlignment = NSTextAlignment.center
        editorLabel.font = UIFont.systemFont(ofSize: 16)
        editorLabel.textAlignment = NSTextAlignment.center
        editorLabel.numberOfLines = 2
        closeLoanButton.setTitle("Close", for: .normal)
        closeLoanButton.addTarget(self, action: #selector(handleCloseLoan), for: .touchUpInside)
    }
    /**
     Function that fetchs loans details for the displayed book
     */
    private func getLoans() {
        // get the Id of the user
        guard let uid = Auth.auth().currentUser?.uid else {return}
        // get the ref of list of loans for this uid
        let ref = Database.database().reference().child(FirebaseUtilities.shared.user_loans).child(uid)
        // observe the node
        ref.observe(.childAdded, with: { (snapshot) in
            // get the key for the message
            let loanId = snapshot.key
            // get the reference of the loan
            let loanReference = Database.database().reference().child(FirebaseUtilities.shared.loan).child(loanId)
            // observe the messages for this user
            loanReference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                guard let toUser = dictionary["toUser"] as? String else {return}
                guard let loanStartDate = dictionary["loanStartDate"] as? String else {return}
                guard let expectedEndDateOfLoan = dictionary["expectedEndDateOfLoan"] as? String else {return}
                guard let bookId = dictionary["bookId"] as? String else {return}
                guard let uniqueLoanBookId = dictionary["uniqueLoanBookId"] as? String else {return}
                FirebaseUtilities.getUserNameFromUserId(userId: toUser, callBack: { (name) in
                    if bookId == self.bookToDisplay?.uniqueId {
                        guard let name = name else {return}
                        self.borrowerLabel.text = "This book is lent to \(name)"
                        self.startingDateOfLoanLabel.text = "Loan from \(loanStartDate)"
                        self.expectedEndDateOfLoanLabel.text = "To \(expectedEndDateOfLoan)"
                        self.currentLoanId = uniqueLoanBookId
                    } 
                })
            }, withCancel: nil)
        }, withCancel: nil)
    }
    /**
     Function that sets up the screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        if let isbn = bookToDisplay?.isbn {
            bookCoverImageView.loadingCoverImageUsingCacheWithisbnString(isbnString: isbn)
        }
        setupBookCoverImageView()
        setupTitleLabel()
        setupAuthorLabel()
        setupEditorLabel()
        setupContainerView()
        setupBorrowerLabel()
        setupStartingDateOfLoanLabel()
        setupExpectedEndDateOfLoanLabel()
        setupCloseLoanButton()
    }
    
    @objc func handleModifyLoan(){
        print(currentLoanId as Any)
        print("will lead to screen to modify the loan")
    }
    
    private func secondConfirmation() {
        let actionSheet = UIAlertController(title: "Dear user", message: "Are you sure to close this loan?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
            // change availability
            self.bookToDisplay?.isAvailable = true
            guard let book = self.bookToDisplay else {return}
            // update availability in Firebase
            FirebaseUtilities.saveBook(book: book, fromUserId: self.currentUid)
            // Todo: set the date for closed loan
            guard let loanIdToClose = self.currentLoanId else {return}
            FirebaseUtilities.closeLoan(for: loanIdToClose)
            self.dismiss(animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion : nil)
    }
    
    
    /**
     Function that closes a loan
     */
    @objc func handleCloseLoan(){
      secondConfirmation()
    }
}
