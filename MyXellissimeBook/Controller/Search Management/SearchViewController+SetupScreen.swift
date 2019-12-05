//
//  SearchViewController+SetupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 22/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - Extension SearchViewController
/**
 This SearchViewController extension gathers functions for screen setup
 */
extension SearchViewController {
    
    /*******************************************************
                            Screen Setup
     ********************************************************/
    /**
     Function that sets up searchLabel
     */
    func setupSearchLabel(){
        // need x and y , width height contraints
        searchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: topbarHeight+50).isActive = true
        searchLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        searchLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    /**
     Function that sets up inputsContainerView
     */
    func setupInputsContrainerView(){
        // need x and y , width height contraints
        // todo : check safe width when rotate
        inputsContainerView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        inputsContainerView.layer.cornerRadius = 5
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: searchLabel.bottomAnchor, constant: 20).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        // add UI objects in the view container
        inputsContainerView.addSubviews(bookTitleTextField,bookTitleSeparatorView,bookAuthorTextField,bookAuthorSeparatorView,bookIsbnTextField, bookIsbnSeparatorView, ownerTextField,ownerSeparatorView,areaTextField)
        // need x and y , width height contraints for bookTitleTextField
        bookTitleTextField.placeholder = "Titre du livre"
        bookTitleTextField.textColor = UIColor.black
        bookTitleTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookTitleTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 0).isActive = true
        bookTitleTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        bookTitleTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        // need x and y , width height contraints for bookTitleSeparatorView
         bookTitleSeparatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bookTitleSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookTitleSeparatorView.topAnchor.constraint(equalTo: bookTitleTextField.bottomAnchor).isActive = true
        bookTitleSeparatorView.widthAnchor.constraint(equalTo: bookTitleTextField.widthAnchor).isActive = true
        bookTitleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        // need x and y , width height contraints for bookAuthorTextField
        bookAuthorTextField.placeholder = "Auteur"
        bookAuthorTextField.textColor = UIColor.black
        bookAuthorTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookAuthorTextField.topAnchor.constraint(equalTo: bookTitleTextField.bottomAnchor, constant: 0).isActive = true
        bookAuthorTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        bookAuthorTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5).isActive = true
        // need x and y , width height contraints for bookAuthorSeparatorView
        bookTitleSeparatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bookAuthorSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookAuthorSeparatorView.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor).isActive = true
        bookAuthorSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookAuthorSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        // need x and y , width height contraints for bookIsbnTextField
        bookIsbnTextField.placeholder = "Numéro ISBN du livre"
        bookIsbnTextField.textColor = UIColor.black
        bookIsbnTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        bookIsbnTextField.topAnchor.constraint(equalTo: bookAuthorTextField.bottomAnchor, constant: 0).isActive = true
        bookIsbnTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        bookIsbnTextField.heightAnchor.constraint(equalTo: bookAuthorTextField.heightAnchor).isActive = true
        bookIsbnSeparatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bookIsbnSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        bookIsbnSeparatorView.topAnchor.constraint(equalTo: bookIsbnTextField.bottomAnchor).isActive = true
        bookIsbnSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        bookIsbnSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        // need x and y , width height contraints for bookIsbnTextField
        ownerTextField.placeholder = "Email du propriétaire du livre"
        ownerTextField.textColor = UIColor.black
        ownerTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        ownerTextField.topAnchor.constraint(equalTo: bookIsbnSeparatorView.bottomAnchor, constant: 0).isActive = true
        ownerTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        ownerTextField.heightAnchor.constraint(equalTo: bookAuthorTextField.heightAnchor).isActive = true
        ownerSeparatorView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ownerSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        ownerSeparatorView.topAnchor.constraint(equalTo: ownerTextField.bottomAnchor).isActive = true
        ownerSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        ownerSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        areaTextField
        areaTextField.placeholder = "Indiquer une ville"
        areaTextField.textColor = UIColor.black
        areaTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        areaTextField.topAnchor.constraint(equalTo: ownerSeparatorView.bottomAnchor, constant: 0).isActive = true
        areaTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        areaTextField.heightAnchor.constraint(equalTo: bookAuthorTextField.heightAnchor).isActive = true
    }
    /**
     Function that sets up searchBookInDatabaseButton
     */
     func setupsearchBookInDatabaseButton(){
        // need x and y , width height contraints
        searchBookInDatabaseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchBookInDatabaseButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 30).isActive = true
        searchBookInDatabaseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBookInDatabaseButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    func setupShowMap() {
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else {return}
        showMap.addTarget(self, action: #selector(displayMap), for: .touchUpInside)
        showMap.setTitle("Localiser des proches utilisateurs", for: .normal)
        showMap.titleLabel?.adjustsFontSizeToFitWidth = true
        showMap.contentScaleFactor = 0.5
        showMap.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showMap.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabbarHeight-20).isActive = true
        showMap.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showMap.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
    }
    
    @objc func displayMap(){
        let mapViewController = MapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
}
