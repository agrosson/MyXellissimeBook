//
//  DetailAvailableBookViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 21/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

class DetailAvailableBookViewController: UIViewController {

    var bookToDisplay: Book?
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
    /// Editor label for the book
    let editorLabel = CustomUI().label
    /// Propose loan Button
    lazy var createALoanButton = CustomUI().button

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
        view.addSubview(createALoanButton)
        setupUIObjects()
        setupScreen()
    }
    
    private func setupUIObjects(){
        titleLabel.font = UIFont.systemFont(ofSize: 40)
        titleLabel.textAlignment = NSTextAlignment.center
        authorLabel.textAlignment = NSTextAlignment.center
        editorLabel.textAlignment = NSTextAlignment.center
        editorLabel.numberOfLines = 2
        createALoanButton.setTitle("Lend this book", for: .normal)
        createALoanButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        createALoanButton.addTarget(self, action: #selector(handleCreateALoan), for: .touchUpInside)
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
        bookCoverImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50+topbarHeight).isActive = true
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
        titleLabel.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor, constant: 50).isActive = true
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
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
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
        editorLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 20).isActive = true
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
    /**
     Function that presents ManageLoanViewController when createALoanButton is pressed
     */
    @objc func handleCreateALoan(){
        if let book = bookToDisplay {
            showManageLoanViewControllerForBook(book: book)
        }
    }
}
