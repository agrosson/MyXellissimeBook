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
        label.text = "Entrer au moins un élément"
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
    /// View as a separator between textField
    let bookIsbnSeparatorView = CustomUI().view
    /// TextField to get book Isbn
    let ownerTextField = CustomUI().textField
    /// View as a separator between textField
    let ownerSeparatorView = CustomUI().view
    /// TextField to get book Isbn
    let areaTextField = CustomUI().textField
    
    /// Launch search in APIs
    lazy var searchBookInDatabaseButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Rechercher le livre", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(searchBook), for: .touchUpInside)
        return button
    }()
    
    lazy var showMap = CustomUI().button
    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        counterInterstitial = 0
        view.addSubviews(searchLabel,inputsContainerView,searchBookInDatabaseButton,showMap)
        
        fetchUserAndSetupNavBarTitle()
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        fetchUserAndSetupNavBarTitle()
        UIApplication.shared.applicationIconBadgeNumber = 0
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
        setupShowMap()
        manageTextField()
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
        ownerTextField.delegate = self
        areaTextField.delegate = self
    }
    
    
    // MARK: - Methods @objc - Actions
    @objc private func searchBook(){
        guard var title = bookTitleTextField.text, var author = bookAuthorTextField.text, var isbn = bookIsbnTextField.text, var email = ownerTextField.text, var area = areaTextField.text else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAtLeastOneField
            return
        }
        title.removeFirstAndLastAndDoubleWhitespace()
        author.removeFirstAndLastAndDoubleWhitespace()
        isbn.removeFirstAndLastAndDoubleWhitespace()
        email.removeFirstAndLastAndDoubleWhitespace()
        area.removeFirstAndLastAndDoubleWhitespace()
        
        if title.isEmpty && author.isEmpty && isbn.isEmpty && email.isEmpty && area.isEmpty {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAtLeastOneField
            return
        }

        let searchBookResultTableViewController = SearchBookResultTableViewController()
        searchBookResultTableViewController.titleSearch = title
        searchBookResultTableViewController.authorSearch = author
        searchBookResultTableViewController.isbnSearch = isbn
        searchBookResultTableViewController.email = email
        searchBookResultTableViewController.area = area
        
        navigationController?.pushViewController(searchBookResultTableViewController, animated: true)
    }
    /**
     Action for tap and Swipe Gesture Recognizer
     */
    @objc private func myTap() {
        bookTitleTextField.resignFirstResponder()
        bookAuthorTextField.resignFirstResponder()
        bookIsbnTextField.resignFirstResponder()
        ownerTextField.resignFirstResponder()
        areaTextField.resignFirstResponder()
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
        ownerTextField.resignFirstResponder()
        areaTextField.resignFirstResponder()
        return true
    }
}
