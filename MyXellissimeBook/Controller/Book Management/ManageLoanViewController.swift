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
    let bookCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    /// Title label for the book
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
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
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
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
    /// Separate view
    let separateView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Container View for Loan details
    let containerInputView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Instruction label for the loan
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter email of borrower"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// TextField to get boorower email
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.keyboardType = UIKeyboardType.default
        textField.textColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    // create button
    /// Validation button for loan
    lazy var validLoanButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Valid", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(validLoan), for: .touchUpInside)
        return button
    }()
    
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
        setupScreen()
    }
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
     Function that presents LoanConfirmationViewController
     */
    private func showConfirmationLoanViewControllerWith(book : Book, and user: User){
       let loanConfirmationVC = LoanConfirmationViewController()
        loanConfirmationVC.bookToLend = book
        loanConfirmationVC.userBorrower = user
        navigationController?.pushViewController(loanConfirmationVC, animated: true)
    }
    
    
    @objc func validLoan(){
        print("valid loan and display confim screen")
        
        print("voyons notre userBorrower")
       // var userFrom = User()
        guard let emailString = emailTextField.text else {return}
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

//        if FirebaseUtilities.getUserFromEmail(email: email).email == nil {
//            Alert.shared.controller = self
//            Alert.shared.alertDisplay = .noUserFound
//            return
//        }
//        else  {
//            guard let book = bookToLend else {return}
//            showConfirmationLoanViewControllerWith(book: book, and: FirebaseUtilities.getUserFromEmail(email: email))
//        }
        
    }
}
