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
    let inputsContainerView = CustomUI().view
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
    /// TextField to get book editor
    let editorTextField = CustomUI().textField
    /// Launch search in APIs
    lazy var searchBookWithApiButton = CustomUI().button
    /// ActivityIndicatorView on searchBookWithApiButton when API research is sent
    let indicatorSearch = CustomUI().activityIndicatorView
    /// ActivityIndicatorView on addBookInFirebaseButton when book is saved in Firebase
    let indicatorSave = CustomUI().activityIndicatorView
    
    // create button
    /// Add book in Firebase database
    lazy var addBookInFirebaseButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Enregistrer le livre", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
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
    
    var originTitle: CGPoint!
    var originAuthor: CGPoint!
    var originEditor: CGPoint!
    
    var priority = "rien pour l'instant"
    var currentLabelText = "empty"
    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(dismissCurrentView))
        view.addSubview(inputsContainerView)
        view.addSubview(searchBookWithApiButton)
        view.addSubview(indicatorSearch)
        view.addSubview(indicatorSave)
        view.addSubview(addBookInFirebaseButton)
        originTitle = labelTitle.center
        originAuthor = labelAuthor.center
        originEditor = labelEditor.center
        setupScreen()
        if bookElementFromPhoto {
            searchBookWithApiButton.isEnabled = false
            displayMessageOfExplanation()
        }
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            priority = "rien pour l'instant"
            currentLabelText = "empty"
            let location = touch.location(in: self.view)
            if labelTitle.frame.contains(location) {
                labelTitle.center = location
                priority = "montitre"
                if labelTitle.text != nil {
                    currentLabelText = labelTitle.text!
                }
            }
            if labelAuthor.frame.contains(location) {
                labelAuthor.center = location
                priority = "monauteur"
                if labelAuthor.text != nil {
                    currentLabelText = labelAuthor.text!
                }
            }
            if labelEditor.frame.contains(location) {
                labelEditor.center = location
                priority = "monediteur"
                if labelEditor.text != nil {
                    currentLabelText = labelEditor.text!
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self.view)
            if labelTitle.frame.contains(location) && priority == "montitre" {
                labelTitle.center = location
            }
            if labelAuthor.frame.contains(location) && priority == "monauteur" {
                labelAuthor.center = location
            }
            if labelEditor.frame.contains(location) && priority == "monediteur"{
                labelEditor.center = location
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self.view)
            let locationWithTopBar = CGPoint(x: location.x, y: location.y-topbarHeight-20)
            if priority != "rien pour l'instant" {
                if bookTitleTextField.frame.contains(locationWithTopBar) {
                    bookTitleTextField.text = currentLabelText
                    hideLabel(with: priority)
                } else if bookAuthorTextField.frame.contains(locationWithTopBar) {
                    bookAuthorTextField.text = currentLabelText
                    hideLabel(with: priority)
                } else if editorTextField.frame.contains(locationWithTopBar) {
                    editorTextField.text = currentLabelText
                    editorTextField.textColor = .black
                    hideLabel(with: priority)
                }
                else {
                    labelTitle.center = originTitle
                    labelAuthor.center = originAuthor
                    labelEditor.center = originEditor
                }
            }
             else {
                labelTitle.center = originTitle
                labelAuthor.center = originAuthor
                labelEditor.center = originEditor
            }
        }
    }
    
    private func hideLabel(with text: String) {
        switch text {
        case "montitre":
            labelTitle.isHidden = true
        case "monauteur":
            labelAuthor.isHidden = true
        case "monediteur":
            labelEditor.isHidden = true
        default:
            print("error somewhere")
        }
    }
    
    private func displayMessageOfExplanation(){
        let actionSheet = UIAlertController(title: "Faites glisser les boutons vers les zones de textes", message: "Vous pourrez modifier/corriger les textes juste après", preferredStyle: .alert)
        
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
                                                let actionSheet = UIAlertController(title: "Désolé",
                                                                                    message: "Aucun livre trouver dans la base de données",
                                                                                    preferredStyle: .alert)
                                                actionSheet.addAction(UIAlertAction(title: "Ajouter manuellement",
                                                                                    style: .default,
                                                                                    handler: { (_: UIAlertAction) in
                                                                                   //     self.dismiss(animated: true)
                                                                                        self.isSearchIndicator(shown: false)
                                                }))
                                                actionSheet.addAction(UIAlertAction(title: "Annuler",
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
        editorTextField.delegate = self
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
    @objc func searchBook(){
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
            if let editor = editorTextField.text {
                myBookToSave.editor = editor
            } else {
                myBookToSave.editor = "Editor unknown"
            }
        } else {
            myBookToSave.title = title
            if bookAuthorTextField.text != "" {
                myBookToSave.author = bookAuthorTextField.text
            } else {
                myBookToSave.author = "Author unknown"
            }
            myBookToSave.isbn = bookIsbnTextField.text ?? ""
            myBookToSave.coverURL = ""
            if let editor = editorTextField.text {
              myBookToSave.editor = editor
            } else {
                myBookToSave.editor = "Editor unknown"
            }
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
        editorTextField.resignFirstResponder()
        return true
    }
}
