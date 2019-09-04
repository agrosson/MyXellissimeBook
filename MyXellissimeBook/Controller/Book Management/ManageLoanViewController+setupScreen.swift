//
//  ManageLoanViewController+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 23/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extension ManageLoanViewController
/**
 This ManageLoanViewController extension gathers functions for screen setup
 */

extension ManageLoanViewController {
     // MARK: - Methods
    /**
     Function that sets up containerView()
     */
    func setupContainerView(){
        // need x and y , width height contraints
        let height:CGFloat = screenHeight/5
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30+topbarHeight).isActive = true
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
        titleLabel.text = bookToLend?.title
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
        authorLabel.text = bookToLend?.author
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
    
    /**
     Function that sets up containerInputView
     */
    func setupContainerInputView(){
        containerInputView.backgroundColor = UIColor.clear
        containerInputView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        containerInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        containerInputView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        containerInputView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -16).isActive = true
    }
   
    /**
     Function that sets up emailTextField
     */
    func setupEmailTextField(){
        emailTextField.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        emailTextField.layer.borderWidth = 2
        emailTextField.layer.cornerRadius = 5
        emailTextField.textAlignment = NSTextAlignment.center
        emailTextField.leftAnchor.constraint(equalTo: containerInputView.leftAnchor, constant:  8).isActive = true
        emailTextField.topAnchor.constraint(equalTo: containerInputView.topAnchor, constant: 40).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: containerInputView.widthAnchor, constant: -16).isActive = true
    }
    /**
     Function that sets up validLoanButton
     */
    func setupValidLoanButton(){
        validLoanButton.leftAnchor.constraint(equalTo: containerInputView.leftAnchor, constant: 8).isActive = true
        validLoanButton.bottomAnchor.constraint(equalTo: containerInputView.bottomAnchor, constant: -8).isActive = true
        validLoanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        validLoanButton.widthAnchor.constraint(equalTo: containerInputView.widthAnchor, constant: -16).isActive = true
    }
}
