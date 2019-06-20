//
//  AddManuallyViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 14/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// MARK: - Class AddManuallyViewController
/**
 This class defines the AddManuallyViewController   
 */

class AddManuallyViewController: UIViewController {
    
    // MARK: - Outlets and properties
    
    /// Book to save on FireBase
    var bookToSave: Book?
    
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
    lazy var searchBookWithApiButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Search book to add", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(searchBook), for: .touchUpInside)
        return button
    }()
    
    // create ActivityIndicatorView
    /// ActivityIndicatorView on searchBookWithApiButton when API research is sent
    let indicatorSearch: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // create ActivityIndicatorView
    /// ActivityIndicatorView on addBookInFirebaseButton when book is saved in Firebase
    let indicatorSave: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = UIColor.white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // create button
    /// Add book in Firebase database
    lazy var addBookInFirebaseButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Save book", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(addAndSaveBookInFireBase), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissCurrentView))
        view.addSubview(inputsContainerView)
        view.addSubview(searchBookWithApiButton)
        view.addSubview(indicatorSearch)
        view.addSubview(indicatorSave)
        view.addSubview(addBookInFirebaseButton)
        setupScreen()
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    
    // MARK: Methods API Request
    /**
     Function to get book information from GoogleBooks API
     */
    private func googleBookCall() {
        // This to ensure that no data remains in the object
        bookToSave = Book()
        // Get the isbn from the user (typed in textfield)
        guard var isbnFromTextField = bookIsbnTextField.text else {
            // Todo: Alert to show
            return
        }
        // Remove inaccurate whitespaces
        isbnFromTextField.removeFirstAndLastAndDoubleWhitespace()
        let api = GoogleBookAPI(isbn: isbnFromTextField)
        guard let fullUrl = api.googleBookFullUrl else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .googleBookAPIProblemWithUrl
            return
        }
        let method = api.httpMethod
        let googleCall = APIManager.shared
        googleCall.getBookInfo(fullUrl: fullUrl, method: method, isbn: api.isbn, callBack: { (_, bookresult) in
            if let book = bookresult {
                self.bookTitleTextField.text = book.title
                self.bookAuthorTextField.text = book.author
                self.bookToSave = book
                self.isSearchIndicator(shown: false)
            } else {
                print("Failure : try openLibrary")
                self.openLibraryCall()
            }
        })
    }
    /**
     Function to get book information from Open Library API
     */
    private func openLibraryCall() {
        // This to ensure that no data remains in the object
        bookToSave = Book()
        // Get the isbn from the user (typed in textfield)
        guard var isbnFromTextField = bookIsbnTextField.text else {
            //todo: alert to show
            return
        }
        isbnFromTextField.removeFirstAndLastAndDoubleWhitespace()
        let api = OpenLibraryAPI(isbn: isbnFromTextField)
        guard let fullUrl = api.openlibraryFullUrl else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .googleBookAPIProblemWithUrl
            return
        }
        let method = api.httpMethod
        let openLibraryCall = APIManager.shared
        openLibraryCall.getBookInfoOpenLibrary(fullUrl: fullUrl,
                                               method: method,
                                               isbn: api.isbn,
                                               callBack: { (_, bookresult) in
                                                if let book = bookresult {
                                                    self.bookIsbnTextField.text = book.title
                                                    self.bookAuthorTextField.text = book.author
                                                    self.bookToSave = book
                                                    self.isSearchIndicator(shown: false)
                                                } else {
                                                    print("Failure : try GoodREads")
                                                    self.goodReadsCall()
                                                }
        })
    }
    /**
     Function to get book information from GoodReads API
     */
    private func goodReadsCall() {
        // This to ensure that no data remains in the object
        bookToSave = Book()
        // Get the isbn from the user (typed in textfield)
        guard var isbnFromTextField = bookIsbnTextField.text else {
            //todo: alert to show
            return
        }
        isbnFromTextField.removeFirstAndLastAndDoubleWhitespace()
        let api = GoodReadsAPI(isbn: isbnFromTextField)
        guard  let fullUrl = api.goodReadsFullUrl
            else {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .googleBookAPIProblemWithUrl
                return
        }
        let method = api.httpMethod
        let goodReadsCall = APIManager.shared
        goodReadsCall.getBookInfoGoodReads(fullUrl: fullUrl,
                                           method: method,
                                           isbn: api.isbn,
                                           callBack: { (_, bookresult) in
                                            if let book = bookresult {
                                                self.bookTitleTextField.text = book.title
                                                self.bookAuthorTextField.text = book.author
                                                self.bookToSave = book
                                                self.isSearchIndicator(shown: false)
                                            } else {
                                                print("Failure : the book has not been found in our databases")
                                                // Alert.shared.controller = self
                                                // Alert.shared.alertDisplay = .bookDidNotFindAResult
                                                let actionSheet = UIAlertController(title: "Sorry",
                                                                                    message: "No book found in databases",
                                                                                    preferredStyle: .alert)
                                                actionSheet.addAction(UIAlertAction(title: "Add Manually",
                                                                                    style: .default,
                                                                                    handler: { (_: UIAlertAction) in
                                                                                        self.dismiss(animated: true)
                                                }))
                                                actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                                                    style: .default,
                                                                                    handler: { (_: UIAlertAction) in
                                                                                        self.dismiss(animated: true)
                                                }))
                                                self.present(actionSheet, animated: true, completion: nil)
                                            }
        })
    }
    
    
    
    // MARK: - Methods
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationItem.title = InitialViewController.titleName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setupInputsContrainerView()
        setupSearchBookWithApiButton()
        setupaddBookInFirebaseButton()
        gestureTapCreation()
        gestureswipeCreation()
        manageTextField()
        if scannedIsbn != "" {
            bookIsbnTextField.text = scannedIsbn
        }
        setupIndicatorSearch()
        setupIndicatorSave()
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
     Function that sets up addWithScanButton
     */
    private func setupSearchBookWithApiButton(){
        // need x and y , width height contraints
        searchBookWithApiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBookWithApiButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 30).isActive = true
        searchBookWithApiButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBookWithApiButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    /**
     Function that sets up addWithScanButton
     */
    private func setupIndicatorSearch(){
        // need x and y , width height contraints
        indicatorSearch.centerXAnchor.constraint(equalTo: searchBookWithApiButton.centerXAnchor).isActive = true
        indicatorSearch.centerYAnchor.constraint(equalTo: searchBookWithApiButton.centerYAnchor).isActive = true
        indicatorSearch.heightAnchor.constraint(equalToConstant: 45).isActive = true
        indicatorSearch.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    /**
     Function that sets up addWithScanButton
     */
    private func setupIndicatorSave(){
        // need x and y , width height contraints
        indicatorSave.centerXAnchor.constraint(equalTo: addBookInFirebaseButton.centerXAnchor).isActive = true
        indicatorSave.centerYAnchor.constraint(equalTo: addBookInFirebaseButton.centerYAnchor).isActive = true
        indicatorSave.heightAnchor.constraint(equalToConstant: 45).isActive = true
        indicatorSave.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    
    /**
     Function that sets up addWithScanButton
     */
    private func setupaddBookInFirebaseButton(){
        // need x and y , width height contraints
        addBookInFirebaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addBookInFirebaseButton.topAnchor.constraint(equalTo: searchBookWithApiButton.bottomAnchor, constant: 30).isActive = true
        addBookInFirebaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addBookInFirebaseButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    /**
     Function that sets up inputsContainerView
     */
    private func setupInputsContrainerView(){
        
        // need x and y , width height contraints
        // todo : check safe width when rotate
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight+100).isActive = true
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
     Function that manages TextField
     */
    private func manageTextField() {
        bookTitleTextField.delegate = self
        bookAuthorTextField.delegate = self
        bookIsbnTextField.delegate = self
    }
    /**
     Function that manages search in API activity indicator
     */
    
    private func isSearchIndicator(shown: Bool){
        if shown {
            indicatorSearch.startAnimating()
            searchBookWithApiButton.isEnabled = false
        } else {
            indicatorSearch.stopAnimating()
            searchBookWithApiButton.isEnabled = true
            scannedIsbn = ""
        }
    }
    /**
     Function that manages save in Firebase activity indicator
     */
    
    private func isSaveIndicator(shown: Bool){
        if shown {
            indicatorSave.startAnimating()
            addBookInFirebaseButton.isEnabled = false
        } else {
            indicatorSave.stopAnimating()
            addBookInFirebaseButton.isEnabled = true
        }
    }
    
    // MARK: - Methods @objc - Actions
    @objc private func dismissCurrentView(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func searchBook(){
        print("launch search on APIs")
        googleBookCall()
        isSearchIndicator(shown: true)
    }
    @objc private func addAndSaveBookInFireBase(){
        print("up load in database")
        isSaveIndicator(shown: true)
        guard let myBookToSave = bookToSave else {return}
        if bookToSave?.isbn == nil || bookToSave?.isbn == "" {
            bookToSave?.isbn = UUID().uuidString
        }
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseUtilities.saveBook(book: myBookToSave, fromUserId: uid)
        // if there is no cover image, this will be the image
        var dataAsImage = UIImage(named: "profileDefault") ?? UIImage()
        if bookToSave?.coverURL?.contains("nophoto") ?? true {
            bookToSave?.coverURL = ""
        }
        if bookToSave?.coverURL != "" {
            if let coverUrl = bookToSave?.coverURL {
                if let url = URL(string: coverUrl) {
                    if  let data = try? Data(contentsOf: url) {
                        if let datatest = UIImage(data: data) {
                            dataAsImage = datatest
                        }
                    }
                }
            }
        }
        guard let isbnToSave = bookToSave?.isbn else { return }
        FirebaseUtilities.saveCoverImage(coverImage: dataAsImage, isbn: isbnToSave)
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
extension AddManuallyViewController: UITextFieldDelegate {
    
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
