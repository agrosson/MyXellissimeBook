//
//  Settings.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 07/10/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Class InitialViewController
/**
 This class defines the InitialViewController
 */
class SettingsViewController: UIViewController {
    
    let containerView = CustomUI().view
    let modifyUserProfileImageButton = CustomUI().button
    let modifyUserPasswordButton = CustomUI().button
    let modifyUserNameButton = CustomUI().button
    let modifyUserEmailButton = CustomUI().button
    
    
    
    override func viewDidLoad() {
        setupNavigationBar()
        setupViews()
    }
    
    
    /**
     Function that sets up views on screen
     */
    fileprivate func setupViews() {
        view.addSubview(containerView)
        containerView.addSubviews(modifyUserProfileImageButton,modifyUserPasswordButton,modifyUserNameButton,modifyUserEmailButton)
        containerView.backgroundColor? = mainBackgroundColor
        setupModifyUserProfileImageButton()
        setupModifyUserPasswordButton()
        setupModifyUserNameButton()
        setupModifyUserEmailButton()
        NSLayoutConstraint.activate([
            // ContainerView
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // modifyUserProfileImageButton
            modifyUserProfileImageButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25 + topbarHeight),
            modifyUserProfileImageButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            modifyUserProfileImageButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            modifyUserProfileImageButton.heightAnchor.constraint(equalToConstant: 60),
            // modifyUserPasswordButton
            modifyUserPasswordButton.topAnchor.constraint(equalTo: modifyUserProfileImageButton.bottomAnchor, constant: 25),
            modifyUserPasswordButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            modifyUserPasswordButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            modifyUserPasswordButton.heightAnchor.constraint(equalToConstant: 60),
            // modifyUserNameButton
            modifyUserNameButton.topAnchor.constraint(equalTo: modifyUserPasswordButton.bottomAnchor, constant: 25),
            modifyUserNameButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            modifyUserNameButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            modifyUserNameButton.heightAnchor.constraint(equalToConstant: 60),
            // modifyUserEmailButton
            modifyUserEmailButton.topAnchor.constraint(equalTo: modifyUserNameButton.bottomAnchor, constant: 25),
            modifyUserEmailButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            modifyUserEmailButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            modifyUserEmailButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    /**
     Function that sets up NavigationBar
     */
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handelCancel))
        navigationItem.leftBarButtonItem?.tintColor = navigationItemColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:navigationItemColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Paramètres"
    }
    /**
     Function that sets up modifyUserProfileImageButton
     */
    fileprivate func setupModifyUserProfileImageButton() {
        modifyUserProfileImageButton.setTitle("Changer ma photo", for: .normal)
        modifyUserProfileImageButton.layer.cornerRadius = 15
        modifyUserProfileImageButton.titleLabel?.font = .systemFont(ofSize: 25)
        modifyUserProfileImageButton.addTarget(self, action: #selector(handleModifyProfilePhoto), for: .touchUpInside)
    }
    
    /**
     Function that sets up modifyUserPasswordButton
     */
    fileprivate func setupModifyUserPasswordButton() {
        modifyUserPasswordButton.setTitle("Changer mon mot de passe", for: .normal)
        modifyUserPasswordButton.layer.cornerRadius = 15
        modifyUserPasswordButton.titleLabel?.font = .systemFont(ofSize: 25)
        modifyUserPasswordButton.addTarget(self, action: #selector(handleModifyPassword), for: .touchUpInside)
    }
    /**
     Function that sets up modifyUserNameButton
     */
    fileprivate func setupModifyUserNameButton() {
        modifyUserNameButton.setTitle("Changer mon nom d'utilisateur", for: .normal)
        modifyUserNameButton.layer.cornerRadius = 15
        modifyUserNameButton.titleLabel?.font = .systemFont(ofSize: 25)
        modifyUserNameButton.addTarget(self, action: #selector(handleModifyUserName), for: .touchUpInside)
    }
    /**
     Function that sets up modifyUserEmailButton
     */
    fileprivate func setupModifyUserEmailButton() {
        modifyUserEmailButton.setTitle("Changer mon email", for: .normal)
        modifyUserEmailButton.layer.cornerRadius = 15
        modifyUserEmailButton.titleLabel?.font = .systemFont(ofSize: 25)
        modifyUserEmailButton.addTarget(self, action: #selector(handleModifyEmail), for: .touchUpInside)
    }
    /**
     Action that dismisses VC when "Retour" button clicked
     */
    @objc private func handelCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    /**
     Action that modifies user profile photo
     */
    @objc private func handleModifyProfilePhoto(){
        print("here modify photo")
    }
    /**
     Action that modifies user password
     */
    @objc private func handleModifyPassword(){
        print("here modify password")
    }
    /**
     Action that modifies user name
     */
    @objc private func handleModifyUserName(){
        print("here modify user name")
    }
    /**
     Action that modifies user name
     */
    @objc private func handleModifyEmail(){
        print("here modify user email")
    }
}
