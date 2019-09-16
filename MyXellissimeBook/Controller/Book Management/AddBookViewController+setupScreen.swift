//
//  AddBookViewController+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 28/08/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

extension AddBookViewController {
    
    /**
     Function that sets up addWithScanButton
     */
    func setupaddWithScanButton(){
        addWithScanButton.setTitle("Scanner l'ISBN d'un livre", for: .normal)
        addWithScanButton.layer.cornerRadius = 15
        addWithScanButton.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addWithScanButton.addTarget(self, action: #selector(scanIsbn), for: .touchUpInside)
        // need x and y , width height contraints
        addWithScanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addWithScanButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        addWithScanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addWithScanButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    /**
     Function that sets up addWithPhotoButton
     */
    func setupaddWithPhotoButton(){
        addWithPhotoButton.layer.cornerRadius = 15
        addWithPhotoButton.setTitle("Prendre une photo d'un livre", for: .normal)
        addWithPhotoButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        // need x and y , width height contraints
        addWithPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addWithPhotoButton.topAnchor.constraint(equalTo: addWithScanButton.bottomAnchor, constant: 30).isActive = true
        addWithPhotoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addWithPhotoButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up activityIndicator
     */
    func setupactivityIndicator(){
        activityIndicator.centerXAnchor.constraint(equalTo: addWithPhotoButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: addWithPhotoButton.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /**
     Function that sets up addManuallyButton
     */
    func setupaddManuallyButton(){
        addManuallyButton.setTitle("Ajouter manuellement", for: .normal)
        addManuallyButton.layer.cornerRadius = 15
        addManuallyButton.addTarget(self, action: #selector(addManually), for: .touchUpInside)
        // need x and y , width height contraints
        addManuallyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addManuallyButton.topAnchor.constraint(equalTo: addWithPhotoButton.bottomAnchor, constant: 30).isActive = true
        addManuallyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addManuallyButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    
    
}
