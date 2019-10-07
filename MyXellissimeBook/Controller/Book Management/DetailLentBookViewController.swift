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
    // MARK: - Properties
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
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(dismissCurrentView))
        let color = #colorLiteral(red: 0.2744090557, green: 0.4518461823, blue: 0.527189374, alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = color
        let textAttributes = [NSAttributedString.Key.foregroundColor:color]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Mon prêt"
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
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
        getLoans()
    }
    // MARK: - Methods
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
            let loanReference = Database.database().reference().child(FirebaseUtilities.shared.loans).child(loanId)
            // observe the details of the loan and get values from it
            loanReference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                guard let toUser = dictionary["toUser"] as? String else {return}
                guard let loanStartDate = dictionary["loanStartDate"] as? Int else {return}
                guard let expectedEndDateOfLoan = dictionary["expectedEndDateOfLoan"] as? Int else {return}
                guard let bookId = dictionary["bookId"] as? String else {return}
                guard let uniqueLoanBookId = dictionary["uniqueLoanBookId"] as? String else {return}
                // Search the name of the borrowwer
                FirebaseUtilities.getUserNameFromUserId(userId: toUser, callBack: { (name) in
                    if bookId == self.bookToDisplay?.uniqueId {
                        guard let name = name else {return}
                        // Fill UI texts
                        self.borrowerLabel.text = "Ce livre est prêté à \(name)"
                        let loanStartDateToDisplay = Date(timeIntervalSince1970: Double(loanStartDate)).formatDateTo_dd_dot_MM_dot_yyyy()
                        self.startingDateOfLoanLabel.text = "Prêt du \(loanStartDateToDisplay)"
                        let expectedEndDateOfLoanToDisplay = Date(timeIntervalSince1970: Double(expectedEndDateOfLoan)).formatDateTo_dd_dot_MM_dot_yyyy()
                        self.expectedEndDateOfLoanLabel.text = "Au \(expectedEndDateOfLoanToDisplay)"
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
    /**
     Function that displays message to confirm loan closing
     */
    private func secondConfirmation() {
        let actionSheet = UIAlertController(title: "Cher Utilisateur", message: "Etes vous sûr de vouloir clôturer le prêt?", preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction) in
            // change availability
            self.bookToDisplay?.isAvailable = true
            guard let book = self.bookToDisplay else {return}
            // update availability in Firebase
            FirebaseUtilities.updateBookAfterLoan(book: book, fromUserId: self.currentUid)
            guard let loanIdToClose = self.currentLoanId else {return}
            FirebaseUtilities.closeLoan(for: loanIdToClose)
            self.dismiss(animated: true, completion: nil)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion : nil)
    }
    
    // MARK: - Methods  - Actions with objc functions
    /**
     Function that closes a loan
     */
    @objc func handleCloseLoan(){
      secondConfirmation()
    }
    // MARK: - Methods @objc - Actions
    @objc private func dismissCurrentView(){
        self.dismiss(animated: true, completion: nil)
    }
}
