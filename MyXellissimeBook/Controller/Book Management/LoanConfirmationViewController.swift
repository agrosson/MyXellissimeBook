//
//  LoanConfirmationViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 23/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import  Firebase

// MARK: - Class LoanConfirmationViewController
/**
 This class enables to confirm and save a book loan
 */
class LoanConfirmationViewController: UIViewController {

    var bookToLend = Book()
    var userBorrower = User()
    
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
    /// SeparateView
    let separateView : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.addSubview(bookCoverImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(separateView)
        setupScreen()
    }
    
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        if let isbn = bookToLend.isbn {
            bookCoverImageView.loadingCoverImageUsingCacheWithisbnString(isbnString: isbn)
        }
        setupBookCoverImageView()
        setupTitleLabel()
        setupAuthorLabel()
        setupContainerView()
        setupSeparateView()
    }

    /**
     Function that sets up containerView()
     */
    func setupContainerView(){
        // need x and y , width height contraints
        let height:CGFloat = screenHeight/6
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10+topbarHeight).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: height).isActive = true
        containerView.widthAnchor.constraint(equalTo : view.widthAnchor, constant: -20).isActive = true
    }
    
    /**
     Function that sets up bookCoverImageView
     */
    func setupBookCoverImageView(){
        // need x and y , width height contraints
        
        bookCoverImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: +20).isActive = true
        bookCoverImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -30).isActive = true
        bookCoverImageView.widthAnchor.constraint(equalTo:containerView.widthAnchor, constant: -3*screenWidth/4).isActive = true
    }
    /**
     Function that sets up titleLabel
     */
    func setupTitleLabel(){
        titleLabel.text = bookToLend.title
        // need x and y , width height contraints
        titleLabel.leftAnchor.constraint(equalTo: bookCoverImageView.rightAnchor, constant: 15).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bookCoverImageView.topAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titleLabel.rightAnchor.constraint(equalTo : containerView.rightAnchor, constant: -8).isActive = true
    }
    /**
     Function that sets up authorLabel
     */
    func setupAuthorLabel(){
        authorLabel.text = bookToLend.author
        // need x and y , width height contraints
        authorLabel.leftAnchor.constraint(equalTo: bookCoverImageView.rightAnchor, constant: 15).isActive = true
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        authorLabel.rightAnchor.constraint(equalTo : containerView.rightAnchor, constant: -8).isActive = true
    }
    /**
     Function that sets up separateView
     */
    func setupSeparateView(){
        separateView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separateView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        separateView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separateView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
    }
}
