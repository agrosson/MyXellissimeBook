//
//  Settings+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/11/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMobileAds

extension SettingsViewController {
    /**
     Function that sets up views on screen
     */
    func setupViews() {
        view.addSubview(containerView)
        containerView.addSubviews(modifyUserProfileImageButton,modifyUserPasswordButton,modifyUserNameButton,modifyUserEmailButton,tutorialButton)
        containerView.backgroundColor? = mainBackgroundColor
        setupModifyUserProfileImageButton()
        setupModifyUserPasswordButton()
        setupModifyUserNameButton()
        setupModifyUserEmailButton()
        setupTutorialButton()
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
            // modifyUserEmailButton
            tutorialButton.topAnchor.constraint(equalTo: modifyUserEmailButton.bottomAnchor, constant: 25),
            tutorialButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tutorialButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tutorialButton.heightAnchor.constraint(equalToConstant: 60),
            
        ])
    }
    /**
     Function that sets up modifyUserProfileImageButton
     */
   func setupTutorialButton() {
        tutorialButton.setTitle("Lancer le tutoriel", for: .normal)
        tutorialButton.layer.cornerRadius = 15
        tutorialButton.titleLabel?.font = .systemFont(ofSize: 25)
        tutorialButton.addTarget(self, action: #selector(handleTutorial), for: .touchUpInside)
    }
    /**
     Function that sets up NavigationBar
     */
    func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = navigationItemColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:navigationItemColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Paramètres"
    }
    /**
     Function that sets up modifyUserProfileImageButton
     */
    func setupModifyUserProfileImageButton() {
        modifyUserProfileImageButton.setTitle("Changer ma photo", for: .normal)
        modifyUserProfileImageButton.layer.cornerRadius = 15
        modifyUserProfileImageButton.titleLabel?.font = .systemFont(ofSize: 25)
        modifyUserProfileImageButton.addTarget(self, action: #selector(handleModifyProfilePhoto), for: .touchUpInside)
    }
    
    /**
     Function that sets up modifyUserPasswordButton
     */
    func setupModifyUserPasswordButton() {
        modifyUserPasswordButton.setTitle("Changer mon mot de passe", for: .normal)
        modifyUserPasswordButton.layer.cornerRadius = 15
        modifyUserPasswordButton.titleLabel?.font = .systemFont(ofSize: 25)
        modifyUserPasswordButton.addTarget(self, action: #selector(handleModifyPassword), for: .touchUpInside)
    }
    /**
     Function that sets up modifyUserNameButton
     */
    func setupModifyUserNameButton() {
        modifyUserNameButton.setTitle("Changer mon nom d'utilisateur", for: .normal)
        modifyUserNameButton.layer.cornerRadius = 15
        modifyUserNameButton.titleLabel?.font = .systemFont(ofSize: 25)
        modifyUserNameButton.addTarget(self, action: #selector(handleModifyUserName), for: .touchUpInside)
    }
    /**
     Function that sets up modifyUserEmailButton
     */
    func setupModifyUserEmailButton() {
        modifyUserEmailButton.setTitle("Changer mon email", for: .normal)
        modifyUserEmailButton.layer.cornerRadius = 15
        modifyUserEmailButton.titleLabel?.font = .systemFont(ofSize: 25)
        modifyUserEmailButton.addTarget(self, action: #selector(handleModifyEmail), for: .touchUpInside)
    }
}
