//
//  DetailBorrowerBookViewController+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


extension DetailBorrowedBookViewController {
    /**
     Function that sets up containerView()
     */
    func setupContainerView(){
        // need x and y , width height contraints
        let height: CGFloat = screenHeight/6
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
        titleLabel.text = bookToDisplay.title
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
        authorLabel.text = bookToDisplay.author
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
        lenderLabel.font = UIFont.systemFont(ofSize: heightOfText)
        guard let lenderId = currentLoan.fromUser else {return}
        FirebaseUtilities.getUserNameFromUserId(userId: lenderId) { (name) in
            guard let nameBorrower = name else {return}
            self.lenderLabel.text = "\(nameBorrower)"
        }
        lenderLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        lenderLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        lenderLabel.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 10).isActive = true
        lenderLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    /**
     Function that sets up fromDateLabel
     */
    func setupFromDateLabel() {
        // need x and y , width height contraints
        fromDateLabel.font = UIFont.systemFont(ofSize: heightOfText)
        guard let date = currentLoan.loanStartDate else {return}
        fromDateLabel.text = "From: \(date))"
        fromDateLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        fromDateLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        fromDateLabel.topAnchor.constraint(equalTo: lenderLabel.bottomAnchor, constant: 10).isActive = true
        fromDateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /**
     Function that sets up toDateLabel
     */
    func setupToDateLabel() {
        // need x and y , width height contraints
        toDateLabel.font = UIFont.systemFont(ofSize: heightOfText)
        guard let date = currentLoan.expectedEndDateOfLoan else {return}
        toDateLabel.text = "To: \(date)"
        toDateLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        toDateLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        toDateLabel.topAnchor.constraint(equalTo: fromDateLabel.bottomAnchor, constant: 10).isActive = true
        toDateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
