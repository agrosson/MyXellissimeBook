//
//  DetailLentBookViewController+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 22/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Extension DetailLentBookViewController
/**
 This DetailLentBookViewController extension gathers functions for screen setup
 */

extension DetailLentBookViewController {
    
    /**
     Function that sets up bookCoverImageView
     */
    func setupBookCoverImageView(){
        // need x and y , width height contraints
        let height = (screenHeight/4)-50
        let width = 3*height/4
        bookCoverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bookCoverImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30+topbarHeight).isActive = true
        bookCoverImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        bookCoverImageView.widthAnchor.constraint(equalToConstant :width).isActive = true
    }
    /**
     Function that sets up titleLabel
     */
    func setupTitleLabel(){
        titleLabel.text = bookToDisplay?.title
        // need x and y , width height contraints
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titleLabel.widthAnchor.constraint(equalTo :view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up authorLabel
     */
    func setupAuthorLabel(){
        authorLabel.text = bookToDisplay?.author
        // need x and y , width height contraints
        authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        authorLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        authorLabel.widthAnchor.constraint(equalTo :view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up editorLabel
     */
    func setupEditorLabel(){
        editorLabel.text = bookToDisplay?.editor
        // need x and y , width height contraints
        editorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editorLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 8).isActive = true
        editorLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        editorLabel.widthAnchor.constraint(equalTo :view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up containerView
     */
    func   setupContainerView(){
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        containerView.topAnchor.constraint(equalTo: editorLabel.bottomAnchor, constant: 8).isActive = true
        containerView.widthAnchor.constraint(equalTo :view.widthAnchor, constant: -16).isActive = true
    }
    /**
     Function that sets up borrowerLabel
     */
    func setupBorrowerLabel(){
        borrowerLabel.font = UIFont.systemFont(ofSize: loanTextSize)
        borrowerLabel.text = "Here the borrower"
        borrowerLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        borrowerLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        borrowerLabel.bottomAnchor.constraint(equalTo: startingDateOfLoanLabel.topAnchor, constant: -insetBetweenLabels).isActive = true
        borrowerLabel.heightAnchor.constraint(equalToConstant: loanDetailsLabelHeight).isActive = true
    }
    /**
     Function that sets up startingDateOfLoanLabel
     */
    func setupStartingDateOfLoanLabel(){
        startingDateOfLoanLabel.font = UIFont.systemFont(ofSize: loanTextSize)
        startingDateOfLoanLabel.text = "Here the staring date of the loan"
        startingDateOfLoanLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        startingDateOfLoanLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        startingDateOfLoanLabel.bottomAnchor.constraint(equalTo: expectedEndDateOfLoanLabel.topAnchor, constant: -insetBetweenLabels).isActive = true
        startingDateOfLoanLabel.heightAnchor.constraint(equalToConstant: loanDetailsLabelHeight).isActive = true
    }
    /**
     Function that sets up expectedEndDateOfLoanLabel
     */
    func setupExpectedEndDateOfLoanLabel(){
        expectedEndDateOfLoanLabel.font = UIFont.systemFont(ofSize: loanTextSize)
        expectedEndDateOfLoanLabel.text = "Here the expected end date of the loan"
        expectedEndDateOfLoanLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        expectedEndDateOfLoanLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        expectedEndDateOfLoanLabel.bottomAnchor.constraint(equalTo: modifyLoanButton.topAnchor, constant: -50).isActive = true
        expectedEndDateOfLoanLabel.heightAnchor.constraint(equalToConstant: loanDetailsLabelHeight).isActive = true
    }
    /**
     Function that sets up modifyLoanButton
     */
    func setupModifyLoanButton(){
        modifyLoanButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        modifyLoanButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        modifyLoanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        modifyLoanButton.widthAnchor.constraint(equalToConstant: (screenWidth/2)-20).isActive = true
    }
    /**
     Function that sets up closeLoanButton
     */
    func setupCloseLoanButton(){
        closeLoanButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
        closeLoanButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        closeLoanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        closeLoanButton.widthAnchor.constraint(equalToConstant: (screenWidth/2)-20).isActive = true
    }
}
