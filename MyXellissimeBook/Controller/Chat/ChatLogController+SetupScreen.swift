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
    // MARK: - Methods
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
        view.addSubviews(containerView,uploadImageView,sendButton,inputTextField,separatorView)
        containerViewSetup()
        uploadImageViewSetup()
        sendButtonSetup()
        inputTextFieldSetup()
        separatorViewSetup()
    }
    /**
     Function that sets up separatorView
     */
    private func separatorViewSetup() {
        separatorView.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        NSLayoutConstraint.activate([
            separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            separatorView.topAnchor.constraint(equalTo: containerView.topAnchor),
            separatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
    /**
     Function that sets up inputTextField
     */
    private func inputTextFieldSetup() {
        NSLayoutConstraint.activate([
            inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8),
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor),
            inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
    }
    /**
     Function that sets up sendButton
     */
    private func sendButtonSetup(){
        sendButton.tintColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        sendButton.setTitle("Envoyer", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
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
        NSLayoutConstraint.activate([
            uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 40),
            uploadImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    /**
     Function that sets up containerView
     */
    private func  containerViewSetup() {
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else {return}
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabbarHeight)
        containerViewBottomAnchor?.isActive = true
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
