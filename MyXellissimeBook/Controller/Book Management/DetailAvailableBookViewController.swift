//
//  DetailAvailableBookViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 21/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

// MARK: - Class DetailAvailableBookViewController
/**
 This class defines the DetailAvailableBookViewController
 */
class DetailAvailableBookViewController: UIViewController {
    // MARK: - Properties
    /// Book that will be displayed
    var bookToDisplay: Book?
    /// Cover of the book
    let bookCoverImageView = CustomUI().imageView
    /// Title label for the book
    let titleLabel = CustomUI().label
    /// Author label for the book
    let authorLabel = CustomUI().label
    /// Editor label for the book
    let editorLabel = CustomUI().label
    /// Propose loan Button
    lazy var createALoanButton = CustomUI().button
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bookCoverImageView)
        view.addSubview(titleLabel)
        view.addSubview(authorLabel)
        view.addSubview(editorLabel)
        view.addSubview(createALoanButton)
        setupUIObjects()
        setupScreen()
    }
    // MARK: - Methods
    /**
     Function that sets up UI objects
     */
    private func setupUIObjects(){
        // add a tapGesture on coverView to modifiy image
        bookCoverImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleModifyCoverImage)))
        // do not forget to enable interaction
        bookCoverImageView.isUserInteractionEnabled = true
        titleLabel.font = UIFont.systemFont(ofSize: 40)
        titleLabel.textAlignment = NSTextAlignment.center
        authorLabel.textAlignment = NSTextAlignment.center
        editorLabel.textAlignment = NSTextAlignment.center
        editorLabel.numberOfLines = 2
        createALoanButton.setTitle("Lend this book", for: .normal)
        createALoanButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        createALoanButton.addTarget(self, action: #selector(handleCreateALoan), for: .touchUpInside)
    }
    /**
     Function that sets up screen
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
        setupCreateALoanButton()
    }
    /**
     Function that sets up bookCoverImageView
     */
    private func setupBookCoverImageView(){
        // need x and y , width height contraints
        let height = (screenHeight/3)-50
        let width = 3*height/4
        bookCoverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bookCoverImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: ((screenHeight > 600) ? 50:30) + topbarHeight).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        bookCoverImageView.widthAnchor.constraint(equalToConstant :width).isActive = true
    }
    /**
     Function that sets up titleLabel
     */
    private func setupTitleLabel(){
        titleLabel.text = bookToDisplay?.title
        // need x and y , width height contraints
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor, constant: (screenHeight > 600) ? 50:30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.widthAnchor.constraint(equalTo :view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up authorLabel
     */
    private func setupAuthorLabel(){
        authorLabel.text = bookToDisplay?.author
        // need x and y , width height contraints
        authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: (screenHeight > 600) ? 30:20).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        authorLabel.widthAnchor.constraint(equalTo :view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up editorLabel
     */
    private func setupEditorLabel(){
        editorLabel.text = bookToDisplay?.editor
        // need x and y , width height contraints
        editorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editorLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: (screenHeight > 600) ? 30:20).isActive = true
        editorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        editorLabel.widthAnchor.constraint(equalTo :view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up createALoanButton
     */
    private func setupCreateALoanButton(){
        // need x and y , width height contraints
        createALoanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createALoanButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        createALoanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createALoanButton.widthAnchor.constraint(equalTo :view.widthAnchor, constant: -40).isActive = true
    }
    
    /**
     Function that manages presentation of ManageLoanViewController
     */
    func showManageLoanViewControllerForBook(book: Book){
        let manageLoanViewController = ManageLoanViewController()
        manageLoanViewController.bookToLend = bookToDisplay
        navigationController?.pushViewController(manageLoanViewController, animated: true)
    }
    // MARK: - Methods  - Actions with objc functions
    /**
     Function that presents ManageLoanViewController when createALoanButton is pressed
     */
    @objc func handleCreateALoan(){
        if let book = bookToDisplay {
            showManageLoanViewControllerForBook(book: book)
        }
    }
    /**
     Function that modifies book cover image
     */
    @objc func handleModifyCoverImage(){
        addPicker()
    }
}


extension DetailAvailableBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     Function that creates a imagePicker and UIAlertController
     */
    func addPicker() {
        // Create a UIImagePickerController
        let imagePickerController = UIImagePickerController()
        // Delegate to the viewController
        imagePickerController.delegate = self
        // Create a UIAlertController
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        //  Action for Camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                // Create picker with source . Camera
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true,completion: nil)
            }
            else {
                let actionSheet = UIAlertController(title: "Camera not available", message: "Click on Cancel", preferredStyle: .alert)
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(actionSheet, animated: true, completion : nil)
            }
        }))
        //  Action for Photo Library
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true,completion: nil)
        }))
        // Action for Cancel
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion : nil)
    }
    /**
     Function that tells the delegate that the user picked a still image or movie and set the image picked as the photo to display on image view choosen.
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // What to do when operation is done
        picker.dismiss(animated: true) {
          print("do something with the image")
            // Save the image as yhe new cover for the book
            guard let isbn = self.bookToDisplay?.isbn else {return}
            // update book cover on screen
            self.bookCoverImageView.image = image
            // update book cover in Storage
            FirebaseUtilities.saveCoverImage(coverImage: image, isbn: isbn)
            // update book cover in cache
            coverCache.setObject(image, forKey: isbn as AnyObject)
            
        }
    }
    /**
     Function that tells the delegate that the user cancelled the pick operation.
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // What to do when operation is done
        picker.dismiss(animated: true, completion: nil)
    }
}
