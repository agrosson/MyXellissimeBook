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
    /// Elements from Photo?
    var bookElementFromPhoto = false
    
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
     let editorTextField = CustomUI().textField
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
    
    let labelTitle = CustomUI().label
    let labelAuthor = CustomUI().label
    let labelEditor = CustomUI().label
    
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
        if bookElementFromPhoto {
            displayMessageOfExplanation()
        }
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    private func displayMessageOfExplanation(){
        let actionSheet = UIAlertController(title: "Drag and drop book attributes", message: "You can modify text after dropping labels", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion : {
            // hide isbn textfield
            self.bookIsbnTextField.isHidden = true
            // create and show editor instead
            self.createEditorTextfield()
            self.createLabels()
        })
        
    }
    
    private func createLabels(){
        view.addSubview(labelTitle)
        view.addSubview(labelAuthor)
        view.addSubview(labelEditor)
        print("on est dans create labels")
        setupLabelTitle()
        setupLabelAuthor()
        setupLabelEditor() 
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
                                                    self.bookTitleTextField.text = book.title
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
                                                                                   //     self.dismiss(animated: true)
                                                                                        self.isSearchIndicator(shown: false)
                                                }))
                                                actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                                                    style: .default,
                                                                                    handler: { (_: UIAlertAction) in
                                                                                        scannedIsbn = ""
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
    func setupScreen(){
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
        isSaveIndicator(shown: true)
        guard var title = bookTitleTextField.text else {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .noTitleForBook
            isSaveIndicator(shown: false)
            return
        }
        title.removeFirstAndLastAndDoubleWhitespace()
        if title.isEmpty {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .noTitleForBook
            isSaveIndicator(shown: false)
            return
        }
        var myBookToSave = Book()
        // Test if bookToSave not nil
        if bookToSave != nil {
            myBookToSave = bookToSave!
        } else {
            myBookToSave.title = title
            if bookAuthorTextField.text != "" {
                myBookToSave.author = bookAuthorTextField.text
            } else {
                myBookToSave.author = "Author unknown"
            }
            myBookToSave.isbn = bookIsbnTextField.text ?? ""
            myBookToSave.coverURL = ""
            myBookToSave.editor = "Editor unknown"
            myBookToSave.isAvailable = true
            myBookToSave.uniqueId = ""
        }
        myBookToSave.title = title
        if bookAuthorTextField.text != "" {
            var text = bookAuthorTextField.text
            text?.removeFirstAndLastAndDoubleWhitespace()
            myBookToSave.author = text
            
        } else {
            myBookToSave.author = "Author unknown"
        }

        if myBookToSave.isbn == nil || myBookToSave.isbn == "" {
            myBookToSave.isbn = UUID().uuidString
        }
        guard let uid = Auth.auth().currentUser?.uid else {
            isSaveIndicator(shown: false)
            return}

        myBookToSave.uniqueId = "\(uid)\(String(describing: myBookToSave.isbn))"
        FirebaseUtilities.saveBook(book: myBookToSave, fromUserId: uid)
        // if there is no cover image, this will be the image
        var dataAsImage = UIImage(named: "profileDefault") ?? UIImage()
        if myBookToSave.coverURL?.contains("nophoto") ?? true {
            myBookToSave.coverURL = ""
        }
        if myBookToSave.coverURL != "" {
            if let coverUrl = myBookToSave.coverURL {
                if let url = URL(string: coverUrl) {
                    if  let data = try? Data(contentsOf: url) {
                        if let datatest = UIImage(data: data) {
                            dataAsImage = datatest
                        }
                    }
                }
            }
        }
        guard let isbnToSave = myBookToSave.isbn else {
            isSaveIndicator(shown: false)
            return }
        FirebaseUtilities.saveCoverImage(coverImage: dataAsImage, isbn: isbnToSave)
        isSaveIndicator(shown: false)
        scannedIsbn = ""
        dismiss(animated: true, completion: nil)
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
