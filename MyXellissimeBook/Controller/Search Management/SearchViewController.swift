//
//  SearchViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - Class SearchViewController
/**
 This class defines the SearchViewController
 */
class SearchViewController: UIViewController {
    
    // MARK: - Outlets and properties
    /// Label to explain what to do
    let searchLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        // do not forget
        label.text = "Please enter at least one element"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 2
        label.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return label
    }()
    
    /// Container View for inputs for books
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // do not forget
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    
    /// TextField to get book title
    let bookTitleTextField = CustomUI().textField
    /// View as a separator between textField
    let bookTitleSeparatorView = CustomUI().view
    /// TextField to get book Author
    let bookAuthorTextField = CustomUI().textField
    /// View as a separator between textField
    let bookAuthorSeparatorView = CustomUI().view
    /// TextField to get book Isbn
    let bookIsbnTextField = CustomUI().textField
    
    // create button
    /// Launch search in APIs
    lazy var searchBookInDatabaseButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Search book", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(searchBook), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchLabel)
        view.addSubview(inputsContainerView)
        view.addSubview(searchBookInDatabaseButton)
        fetchUserAndSetupNavBarTitle()
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        fetchUserAndSetupNavBarTitle()
    }
    
    
    func fetchUserAndSetupNavBarTitle(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child(FirebaseUtilities.shared.users).child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                
                let user = User()
                
                guard let name = dictionary["name"] as? String else {return}
                guard let email = dictionary["email"] as? String else {return}
                guard let profileId = dictionary["profileId"] as? String else {return}
                
                user.name = name
                user.email = email
                user.profileId = profileId
                self.setupScreen(user: user)
            }
        }
    }
    // MARK: - Methods
    /**
     Function that setup screen
     */
    private func setupScreen(user: User){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationItem.titleView = setupNavBarWithUser(user: user)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        gestureTapCreation()
        gestureswipeCreation()
        setupSearchLabel()
        setupInputsContrainerView()
        setupsearchBookInDatabaseButton()
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
        bookTitleTextField.delegate = self
        bookAuthorTextField.delegate = self
        bookIsbnTextField.delegate = self
    }
    
    
    // MARK: - Methods @objc - Actions
    @objc private func searchBook(){
        guard var title = bookTitleTextField.text, var author = bookAuthorTextField.text, var isbn = bookIsbnTextField.text else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAtLeastOneField
            return
        }
        title.removeFirstAndLastAndDoubleWhitespace()
        author.removeFirstAndLastAndDoubleWhitespace()
        isbn.removeFirstAndLastAndDoubleWhitespace()
        
        if title.isEmpty && author.isEmpty && isbn.isEmpty {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAtLeastOneField
            return
        }

        let searchBookResultTableViewController = SearchBookResultTableViewController()
        searchBookResultTableViewController.titleSearch = title
        searchBookResultTableViewController.authorSearch = author
        searchBookResultTableViewController.isbnSearch = isbn
        navigationController?.pushViewController(searchBookResultTableViewController, animated: true)
    }
    /**
     Action for tap and Swipe Gesture Recognizer
     */
    @objc private func myTap() {
        bookTitleTextField.resignFirstResponder()
        bookAuthorTextField.resignFirstResponder()
        bookIsbnTextField.resignFirstResponder()
    }
    
}
// MARK: - Extensions   UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    /**
     UITextFieldDelegate : defines how textFieldShouldReturn
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        bookTitleTextField.resignFirstResponder()
        bookAuthorTextField.resignFirstResponder()
        bookIsbnTextField.resignFirstResponder()
        return true
    }
}
