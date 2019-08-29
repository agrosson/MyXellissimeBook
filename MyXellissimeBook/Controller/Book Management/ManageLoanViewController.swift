//
//  ManageLoanViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 22/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - Class ManageLoanViewController
/**
 This class enables to create and manage book laon
 */
class ManageLoanViewController: UIViewController {
    // MARK: - Properties
    /// The book to lend
    var bookToLend: Book?
    /// Current user uid
    var userUid: String? = {
       return Auth.auth().currentUser?.uid
    }()
    
    let screenHeight = UIScreen.main.bounds.height
    
    /*******************************************************
                    UI variables: Start
     ********************************************************/
    /// Cover of the book
    let bookCoverImageView = CustomUI().imageView
    /// Title label for the book
    let titleLabel = CustomUI().label
    /// Author label for the book
    let authorLabel = CustomUI().label
    /// Container View for Loan details
    let containerView = CustomUI().view
    /// Separate view
    let separateView  = CustomUI().view
    /// Container View for Loan details
    let containerInputView = CustomUI().view
    /// Instruction label for the loan
    let emailLabel = CustomUI().label
    /// TextField to get boorower email
    let emailTextField = CustomUI().textField
    /// Validation button for loan
    lazy var validLoanButton = CustomUI().button

    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.addSubview(bookCoverImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(separateView)
        containerInputView.addSubview(emailLabel)
        containerInputView.addSubview(emailTextField)
        containerInputView.addSubview(validLoanButton)
        view.addSubview(containerInputView)
        gestureTapCreation()
        gestureswipeCreation()
        manageTextField()
        setupUIObjects()
        setupScreen()
    }
    /**
     Function that sets up customUI objects
     */
    private func setupUIObjects(){
        bookCoverImageView.contentMode = .scaleAspectFit
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        separateView.backgroundColor = .white
        emailLabel.text = "Please enter email of borrower"
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        emailTextField.placeholder = "Email address"
        validLoanButton.setTitle("Valid", for: .normal)
        validLoanButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        validLoanButton.layer.cornerRadius = 15
        validLoanButton.addTarget(self, action: #selector(validLoan), for: .touchUpInside)
    }
    /**
     Function that sets up the screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        if let isbn = bookToLend?.isbn {
            bookCoverImageView.loadingCoverImageUsingCacheWithisbnString(isbnString: isbn)
        }
        setupBookCoverImageView()
        setupTitleLabel()
        setupAuthorLabel()
        setupContainerView()
        setupSeparateView()
        setupContainerInputView()
        setupEmailLabel()
        setupEmailTextField()
        setupValidLoanButton()
    }
    /**
     Function that creates a tap Gesture Recognizer
     */
    private func gestureTapCreation() {
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTap
            ))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(mytapGestureRecognizer)
    }
    /**
     Function that creates a Swipe Gesture Recognizer
     */
    private func gestureswipeCreation() {
        let mySwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(myTap
            ))
        mySwipeGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(mySwipeGestureRecognizer)
    }
    /**
     Function that manages TextField
     */
    private func manageTextField() {
        emailTextField.delegate = self
    }
    /**
     Action for tap and Swipe Gesture Recognizer
     */
    @objc private func myTap() {
        emailTextField.resignFirstResponder()
    }
    /**
     Function that presents LoanConfirmationViewController
     */
    private func showConfirmationLoanViewControllerWith(book : Book, and user: User){
       let loanConfirmationVC = LoanConfirmationViewController()
        loanConfirmationVC.bookToLend = book
        loanConfirmationVC.userBorrower = user
        navigationController?.pushViewController(loanConfirmationVC, animated: true)
    }
    
    
    @objc func validLoan(){

       // var userFrom = User()
        guard var emailString = emailTextField.text else {return}
        // Test if user want to lent to himself
        guard let currentUserEmail = Auth.auth().currentUser?.email else {return}
        if emailString == currentUserEmail {
            let actionSheet = UIAlertController(title: "Sorry", message: "You can not lend this book to yourself", preferredStyle: .alert)
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion : nil)
            return
        } else {
            emailString.removeFirstAndLastAndDoubleWhitespace()
            FirebaseUtilities.getUserFromEmail(email: emailString) { (user) in
                print("test \(String(describing: user.name))")
                if user.name == nil {
                    Alert.shared.controller = self
                    Alert.shared.alertDisplay = .noUserFound
                } else {
                    guard let book = self.bookToLend else {return}
                    self.showConfirmationLoanViewControllerWith(book: book, and: user)
                }
            }
        }
        
        
    }
}

extension ManageLoanViewController : UITextFieldDelegate {
    /**
     UITextFieldDelegate : defines how textFieldShouldReturn
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validLoan()
        textField.resignFirstResponder()
        return true
    }
}
