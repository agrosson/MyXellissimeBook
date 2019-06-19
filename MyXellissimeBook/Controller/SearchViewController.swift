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
    let bookTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Book title"
        textField.keyboardType = UIKeyboardType.default
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    /// View as a separator between textField
    let bookTitleSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// TextField to get book Author
    let bookAuthorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Book author"
        textField.keyboardType = UIKeyboardType.default
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    /// View as a separator between textField
    let bookAuthorSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// TextField to get book Isbn
    let bookIsbnTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Book Isbn"
        textField.keyboardType = UIKeyboardType.default
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
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
     Function that sets up inputsContainerView
     */
    private func setupSearchLabel(){
        
        // need x and y , width height contraints
        searchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight+100).isActive = true
        searchLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        searchLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    }
    /**
     Function that sets up inputsContainerView
     */
    private func setupInputsContrainerView(){
        
        // need x and y , width height contraints
        // todo : check safe width when rotate
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 100).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // add UI objects in the view container
        inputsContainerView.addSubview(bookTitleTextField)
        inputsContainerView.addSubview(bookTitleSeparatorView)
        inputsContainerView.addSubview(bookAuthorTextField)
        inputsContainerView.addSubview(bookAuthorSeparatorView)
        inputsContainerView.addSubview(bookIsbnTextField)
        
        // need x and y , width height contraints for bookTitleTextField
        bookTitleTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookTitleTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 0).isActive = true
        bookTitleTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookTitleTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        // need x and y , width height contraints for bookTitleSeparatorView
        bookTitleSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookTitleSeparatorView.topAnchor.constraint(equalTo: bookTitleTextField.bottomAnchor).isActive = true
        bookTitleSeparatorView.widthAnchor.constraint(equalTo: bookTitleTextField.widthAnchor).isActive = true
        bookTitleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // need x and y , width height contraints for bookAuthorTextField
        bookAuthorTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookAuthorTextField.topAnchor.constraint(equalTo: bookTitleTextField.bottomAnchor, constant: 0).isActive = true
        bookAuthorTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookAuthorTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        // need x and y , width height contraints for bookAuthorSeparatorView
        bookAuthorSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookAuthorSeparatorView.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor).isActive = true
        bookAuthorSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookAuthorSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // need x and y , width height contraints for bookIsbnTextField
        bookIsbnTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookIsbnTextField.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor, constant: 0).isActive = true
        bookIsbnTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookIsbnTextField.heightAnchor.constraint(equalTo: bookAuthorTextField.heightAnchor).isActive = true
    }
    
    /**
     Function that sets up addWithScanButton
     */
    private func setupsearchBookInDatabaseButton(){
        // need x and y , width height contraints
        searchBookInDatabaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBookInDatabaseButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 30).isActive = true
        searchBookInDatabaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBookInDatabaseButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
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
        print("launch search in database")
        // todo: present a tableVC if found otherwise alert not found : search another one or buy on amazon
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
