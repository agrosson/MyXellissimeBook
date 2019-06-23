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

    var bookToDisplay: Book?
    let loanDetailsLabelHeight:CGFloat = {
        if screenHeight > 700 {
            return 60
        } else if screenHeight > 600 {
            return 40}
        return 35 }()
    
    let loanTextSize: CGFloat = 22
    let insetBetweenLabels: CGFloat = {
        if screenHeight > 700 {
            return 20
        }
        return 10 }()
    
    var  currentUid: String  {
        guard let uid = Auth.auth().currentUser?.uid else {return ""}
        return uid
    }
    

    /*******************************************************
     UI variables: Start
     ********************************************************/
    /// Cover of the book
    let bookCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    /// Title label for the book
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Author label for the book
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Editor label for the book
    let editorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Container View for Loan details
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Borrower label for the lent book
    let borrowerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Starting date for the lent
    let startingDateOfLoanLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Expected end date for the lent
    let expectedEndDateOfLoanLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // create button
    /// Modify loan Button
    lazy var modifyLoanButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Modify", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleModifyLoan), for: .touchUpInside)
        return button
    }()
    // create button
    /// Close loan Button
    lazy var closeLoanButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Close", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleCloseLoan), for: .touchUpInside)
        return button
    }()

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
        containerView.addSubview(modifyLoanButton)
        containerView.addSubview(closeLoanButton)
        setupScreen()
        getLoans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
        getLoans()
    }
    
    private func getLoans() {
        // get the Id of the user
        guard let uid = Auth.auth().currentUser?.uid else {return}
        // get the ref of list of message for this uid
        let ref = Database.database().reference().child(FirebaseUtilities.shared.user_loans).child(uid)
        // observe the node
        ref.observe(.childAdded, with: { (snapshot) in
            // get the key for the message
            let loanId = snapshot.key
            // get the reference of the message
            let loanReference = Database.database().reference().child(FirebaseUtilities.shared.loan).child(loanId)
            // observe the messages for this user
            loanReference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                guard let toUser = dictionary["toUser"] as? String else {return}
                guard let loanStartDate = dictionary["loanStartDate"] as? String else {return}
                guard let expectedEndDateOfLoan = dictionary["expectedEndDateOfLoan"] as? String else {return}
                guard let bookId = dictionary["bookId"] as? String else {return}
                FirebaseUtilities.getUserNameFromUserId(userId: toUser, callBack: { (name) in
                    if bookId == self.bookToDisplay?.uniqueId {
                        self.borrowerLabel.text = name
                        self.startingDateOfLoanLabel.text = "Loan from \(loanStartDate)"
                        self.expectedEndDateOfLoanLabel.text = "To \(expectedEndDateOfLoan)"
                    } 
                })
               
            }, withCancel: nil)
        }, withCancel: nil)
        
        
    }
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
        setupModifyLoanButton()
        setupCloseLoanButton()
    }
    
    @objc func handleModifyLoan(){
        print("will lead to screen to modify the loan")
    }
    @objc func handleCloseLoan(){
        bookToDisplay?.isAvailable = true
        guard let book = bookToDisplay else {return}
        FirebaseUtilities.saveBook(book: book, fromUserId: currentUid)
        dismiss(animated: true, completion: nil)
        // Todo: set the date for closed loan
    }
}
