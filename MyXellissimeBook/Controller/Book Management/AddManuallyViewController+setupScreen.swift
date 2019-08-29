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
        editorTextField.textColor = .black
        
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
        searchBookWithApiButton.setTitle("Search book to add", for: .normal)
        searchBookWithApiButton.layer.cornerRadius = 15
        searchBookWithApiButton.addTarget(self, action: #selector(searchBook), for: .touchUpInside)
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
    
    func setupLabelTitle() {
        print("on est setTitle")
        labelTitle.backgroundColor = .white
        labelTitle.layer.cornerRadius = 5
        labelTitle.layer.borderWidth = 2
        labelTitle.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelTitle.text = bookToSave?.title
        labelTitle.textColor = .black
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont.systemFont(ofSize: 20)
        // need x and y , width height contraints
        labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelTitle.topAnchor.constraint(equalTo:addBookInFirebaseButton.bottomAnchor, constant: 20).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
    }
    func setupLabelAuthor() {
        labelAuthor.backgroundColor = .white
        labelAuthor.layer.cornerRadius = 15
        labelAuthor.layer.borderWidth = 2
        labelAuthor.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelAuthor.text = bookToSave?.author
        labelAuthor.textColor = .black
        labelAuthor.textAlignment = .center
        labelAuthor.font = UIFont.systemFont(ofSize: 20)
        // need x and y , width height contraints
        labelAuthor.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelAuthor.topAnchor.constraint(equalTo:labelTitle.bottomAnchor, constant: 20).isActive = true
        labelAuthor.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelAuthor.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
    }
    func setupLabelEditor() {
        labelEditor.backgroundColor = .white
        labelEditor.layer.cornerRadius = 5
        labelEditor.layer.borderWidth = 2
        labelEditor.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        labelEditor.text = bookToSave?.editor
        labelEditor.textColor = .black
        labelEditor.textAlignment = .center
        labelEditor.font = UIFont.systemFont(ofSize: 20)
        // need x and y , width height contraints
        labelEditor.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelEditor.topAnchor.constraint(equalTo:labelAuthor.bottomAnchor, constant: 20).isActive = true
        labelEditor.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelEditor.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    
    /**
     Function that sets up inputsContainerView
     */
    func setupInputsContrainerView(){
        inputsContainerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        inputsContainerView.layer.cornerRadius = 5
        // need x and y , width height contraints
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
        
        
        bookTitleTextField.placeholder = "Book title"
        bookTitleTextField.textColor = .black
        // need x and y , width height contraints for bookTitleTextField
        bookTitleTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookTitleTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 0).isActive = true
        bookTitleTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookTitleTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        bookTitleSeparatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // need x and y , width height contraints for bookTitleSeparatorView
        bookTitleSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookTitleSeparatorView.topAnchor.constraint(equalTo: bookTitleTextField.bottomAnchor).isActive = true
        bookTitleSeparatorView.widthAnchor.constraint(equalTo: bookTitleTextField.widthAnchor).isActive = true
        bookTitleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        bookAuthorTextField.placeholder = "Book author"
        bookAuthorTextField.textColor = .black
        // need x and y , width height contraints for bookAuthorTextField
        bookAuthorTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookAuthorTextField.topAnchor.constraint(equalTo: bookTitleTextField.bottomAnchor, constant: 0).isActive = true
        bookAuthorTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookAuthorTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        bookAuthorSeparatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        // need x and y , width height contraints for bookAuthorSeparatorView
        bookAuthorSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookAuthorSeparatorView.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor).isActive = true
        bookAuthorSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookAuthorSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        bookIsbnTextField.textColor = .black
        bookIsbnTextField.placeholder = "Book Isbn"
        // need x and y , width height contraints for bookIsbnTextField
        bookIsbnTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookIsbnTextField.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor, constant: 0).isActive = true
        bookIsbnTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookIsbnTextField.heightAnchor.constraint(equalTo: bookAuthorTextField.heightAnchor).isActive = true
    }
}
