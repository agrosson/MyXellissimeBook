//
//  ChatLogController+SetupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/08/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit



// MARK: - Extension ChatLogController
/**
 This ChatLogController extension gathers functions for screen setup
 */
extension ChatLogController {
    /**
     Function that sets up all attributes of collectionView
     */
    func collectionViewSetup(){
        // Inset from top (first bubble)
        collectionView.contentInset.top = 8
        collectionView.contentInset.bottom = 60
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        // Scroll activated
        collectionView.alwaysBounceVertical = true
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        // register the cell as a ChatMessageCell
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    /**
     Function that setup layout of container for writing
     */
    func setInputComponents(){
        inputTextField.placeholder = "Taper votre message"
        inputTextField.delegate = self
        view.addSubview(containerView)
        containerViewSetup()
        containerView.addSubview(uploadImageView)
        uploadImageViewSetup()
        containerView.addSubview(sendButton)
        sendButtonSetup()
        containerView.addSubview(inputTextField)
        inputTextFieldSetup()
        containerView.addSubview(separatorView)
        separatorViewSetup()
    }
    /**
     Function that sets up separatorView
     */
    private func separatorViewSetup() {
        separatorView.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    /**
     Function that sets up inputTextField
     */
    private func inputTextFieldSetup() {
        // need x and y , width height contraints
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    }
    /**
     Function that sets up sendButton
     */
    private func sendButtonSetup(){
        sendButton.tintColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        sendButton.setTitle("Envoyer", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        // need x and y , width height contraints
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
    }
    /**
     Function that sets up uploadImageView
     */
    private func uploadImageViewSetup() {
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        uploadImageView.setImage(tintedImage, for: .normal)
        uploadImageView.tintColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        uploadImageView.layer.cornerRadius = 0
        uploadImageView.layer.borderWidth = 0
        uploadImageView.addTarget(self, action: #selector(handleUploadTap), for: .touchUpInside)
        
        // need x and y , width height contraints
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    /**
     Function that sets up containerView
     */
    private func  containerViewSetup() {
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else {return}
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabbarHeight)
        containerViewBottomAnchor?.isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}
