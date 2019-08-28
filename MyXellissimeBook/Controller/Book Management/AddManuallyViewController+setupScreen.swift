//
//  AddManuallyViewController+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 21/08/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

extension AddManuallyViewController {
   
    func  createEditorTextfield() {
        editorTextField.placeholder = "Book Editor"
        // need x and y , width height contraints for bookIsbnTextField
        editorTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        editorTextField.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor, constant: 0).isActive = true
        editorTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        editorTextField.heightAnchor.constraint(equalTo: bookAuthorTextField.heightAnchor).isActive = true
    }
    
    /**
     Function that sets up addWithScanButton
     */
    func setupSearchBookWithApiButton(){
        // need x and y , width height contraints
        searchBookWithApiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBookWithApiButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 30).isActive = true
        searchBookWithApiButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBookWithApiButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    /**
     Function that sets up addWithScanButton
     */
    func setupIndicatorSearch(){
        // need x and y , width height contraints
        indicatorSearch.centerXAnchor.constraint(equalTo: searchBookWithApiButton.centerXAnchor).isActive = true
        indicatorSearch.centerYAnchor.constraint(equalTo: searchBookWithApiButton.centerYAnchor).isActive = true
        indicatorSearch.heightAnchor.constraint(equalToConstant: 45).isActive = true
        indicatorSearch.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    /**
     Function that sets up addWithScanButton
     */
    func setupIndicatorSave(){
        // need x and y , width height contraints
        indicatorSave.centerXAnchor.constraint(equalTo: addBookInFirebaseButton.centerXAnchor).isActive = true
        indicatorSave.centerYAnchor.constraint(equalTo: addBookInFirebaseButton.centerYAnchor).isActive = true
        indicatorSave.heightAnchor.constraint(equalToConstant: 45).isActive = true
        indicatorSave.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    /**
     Function that sets up addWithScanButton
     */
    func setupaddBookInFirebaseButton(){
        // need x and y , width height contraints
        addBookInFirebaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addBookInFirebaseButton.topAnchor.constraint(equalTo: searchBookWithApiButton.bottomAnchor, constant: 30).isActive = true
        addBookInFirebaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addBookInFirebaseButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    /**
     Function that sets up inputsContainerView
     */
    func setupInputsContrainerView(){
        
        // need x and y , width height contraints
        // todo : check safe width when rotate
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight+100).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // add UI objects in the view container
        inputsContainerView.addSubview(bookTitleTextField)
        inputsContainerView.addSubview(bookTitleSeparatorView)
        inputsContainerView.addSubview(bookAuthorTextField)
        inputsContainerView.addSubview(bookAuthorSeparatorView)
        inputsContainerView.addSubview(bookIsbnTextField)
        inputsContainerView.addSubview(editorTextField)
        
        // need x and y , width height contraints for bookTitleTextField
        bookTitleTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookTitleTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 0).isActive = true
        bookTitleTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookTitleTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        
        // need x and y , width height contraints for bookTitleSeparatorView
        bookTitleSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookTitleSeparatorView.topAnchor.constraint(equalTo: bookTitleTextField.bottomAnchor).isActive = true
        bookTitleSeparatorView.widthAnchor.constraint(equalTo: bookTitleTextField.widthAnchor).isActive = true
        bookTitleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // need x and y , width height contraints for bookAuthorTextField
        bookAuthorTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookAuthorTextField.topAnchor.constraint(equalTo: bookTitleTextField.bottomAnchor, constant: 0).isActive = true
        bookAuthorTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookAuthorTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        // need x and y , width height contraints for bookAuthorSeparatorView
        bookAuthorSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookAuthorSeparatorView.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor).isActive = true
        bookAuthorSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookAuthorSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // need x and y , width height contraints for bookIsbnTextField
        bookIsbnTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookIsbnTextField.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor, constant: 0).isActive = true
        bookIsbnTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookIsbnTextField.heightAnchor.constraint(equalTo: bookAuthorTextField.heightAnchor).isActive = true
    }
}
