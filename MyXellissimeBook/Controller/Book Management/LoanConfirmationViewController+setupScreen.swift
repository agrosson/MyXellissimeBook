//
//  LoanConfirmationViewController+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit

extension LoanConfirmationViewController {
    // MARK: - Methods
    /**
     Function that sets up containerView()
     */
    func setupContainerView(){
        // need x and y , width height contraints
        let height:CGFloat = screenHeight/6
        
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if #available(iOS 11.0, *) {
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        } else {
             containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        }
        containerView.heightAnchor.constraint(equalToConstant: height + topbarHeight).isActive = true
        containerView.widthAnchor.constraint(equalTo : view.widthAnchor, constant: -20).isActive = true
    }
    
    /**
     Function that sets up bookCoverImageView
     */
    func setupBookCoverImageView(){
        // need x and y , width height contraints
        
        bookCoverImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: +30).isActive = true
        bookCoverImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: +5).isActive = true
        bookCoverImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        bookCoverImageView.widthAnchor.constraint(equalTo:containerView.widthAnchor, multiplier: 0.2).isActive = true
    }
    /**
     Function that sets up titleLabel
     */
    func setupTitleLabel(){
        titleLabel.text = bookToLend.title
        // need x and y , width height contraints
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/2).isActive = true
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
        authorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenWidth/2).isActive = true
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
     Function that sets up containerDataView
     */
    func setupContainerDataView(){
        // need x and y , width height contraints
        containerDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerDataView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
        containerDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        containerDataView.widthAnchor.constraint(equalTo : view.widthAnchor, constant: -16).isActive = true
    }
    
    /**
     Function that sets up reminderLabel
     */
    func setupReminderLabel(){
        // need x and y , width height contraints
        reminderLabel.font = UIFont.systemFont(ofSize: heightOfText)
        reminderLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        reminderLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        reminderLabel.topAnchor.constraint(equalTo: containerDataView.topAnchor, constant: 10).isActive = true
        reminderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    /**
     Function that sets up borrower Label
     */
    func setupBorrowerLabel() {
        // need x and y , width height contraints
        borrowerLabel.font = UIFont.systemFont(ofSize: heightOfText)
        guard let name = userBorrower.name else {return}
        guard let email = userBorrower.email else {return}
        borrowerLabel.text = "\(name.uppercased()) qui a pour email: \(email)"
        borrowerLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        borrowerLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        borrowerLabel.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 10).isActive = true
        borrowerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    /**
     Function that sets up fromDateLabel
     */
    func setupFromDateLabel() {
        let fromDateToDisplay = Date(timeIntervalSince1970: Double(fromDate)).formatDateTo_dd_dot_MM_dot_yyyy()
        // need x and y , width height contraints
        fromDateLabel.font = UIFont.systemFont(ofSize: heightOfText)
        fromDateLabel.text = "Du: \(fromDateToDisplay)"
        fromDateLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        fromDateLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        fromDateLabel.topAnchor.constraint(equalTo: borrowerLabel.bottomAnchor, constant: 10).isActive = true
        fromDateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /**
     Function that sets up toDateLabel
     */
    func setupToDateLabel() {
        let toDateToDisplay = Date(timeIntervalSince1970: Double(toDate)).formatDateTo_dd_dot_MM_dot_yyyy()
        // need x and y , width height contraints
        toDateLabel.font = UIFont.systemFont(ofSize: heightOfText)
        toDateLabel.text = "Au: \(toDateToDisplay)"
        toDateLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        toDateLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        toDateLabel.topAnchor.constraint(equalTo: fromDateLabel.bottomAnchor, constant: 10).isActive = true
        toDateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /**
     Function that sets up confirmLoanButton
     */
    func setupConfirmLoanButton() {
        // need x and y , width height contraints
        confirmLoanButton.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        confirmLoanButton.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        confirmLoanButton.bottomAnchor.constraint(equalTo: containerDataView.bottomAnchor, constant: -12).isActive = true
        confirmLoanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
