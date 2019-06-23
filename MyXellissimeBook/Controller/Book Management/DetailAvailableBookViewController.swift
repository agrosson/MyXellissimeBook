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
    let bookCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    /// Title label for the book
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Author label for the book
    let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /// Editor label for the book
    let editorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // create button
    /// Propose loan Button
    lazy var createALoanButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Lend this book", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleCreateALoan), for: .touchUpInside)
        return button
    }()
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
        setupScreen()
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
        print("go to screen for create a loan")
        if let book = bookToDisplay {
            showManageLoanViewControllerForBook(book: book)
        }
    }
}
