//
//  SearchBookDetailViewController+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


extension SearchBookDetailViewController {
    /**
     Function that sets up containerView()
     */
    func setupContainerView(){
        // need x and y , width height contraints
         let height: CGFloat = typeOfDevice == "large" ? screenHeight/4: screenHeight/6
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20+topbarHeight).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: height+60).isActive = true
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
        titleLabel.leftAnchor.constraint(equalTo: bookCoverImageView.rightAnchor, constant: 20).isActive = true
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
        authorLabel.leftAnchor.constraint(equalTo: bookCoverImageView.rightAnchor, constant: 20).isActive = true
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
        reminderLabel.font = UIFont.systemFont(ofSize: 30)
        reminderLabel.textAlignment = NSTextAlignment.center
        reminderLabel.numberOfLines = 0
        reminderLabel.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        reminderLabel.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        reminderLabel.topAnchor.constraint(equalTo: containerDataView.topAnchor, constant: 10).isActive = true
        reminderLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }
}
