//
//  LoginController+setupScreen.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 21/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase


// MARK: - Extension LoginController
/**
 This LoginController extension gathers functions for screen setup
 */
extension LoginController {
    
    /*******************************************************
                        Screen Setup
     ********************************************************/
    /**
     Function that sets up setuploginRegisteredSegmentedControl
     */
     func setuploginRegisteredSegmentedControl(){
        // need x and y , width height contraints
        loginRegisteredSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisteredSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisteredSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisteredSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    /**
     Function that sets up profileImageView
     */
     func setupProfileImageView(){
        // need x and y , width height contraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisteredSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    /**
     Function that sets up inputsContainerView
     */
     func setupInputsContrainerView(){
        // need x and y , width height contraints
        // todo : check safe width when rotate
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightConstraint = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightConstraint?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        // need x and y , width height contraints for nameTextfield
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: 0).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldViewHeightConstraint =  nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldViewHeightConstraint?.isActive = true
        
        // need x and y , width height contraints for nameSeparator
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameSeperatorTextFieldViewHeightConstraint =  nameSeparatorView.heightAnchor.constraint(equalToConstant: 1)
        nameSeperatorTextFieldViewHeightConstraint?.isActive = true
        
        // need x and y , width height contraints for emailTextfield
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 0).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldViewHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldViewHeightConstraint?.isActive = true
        
        // need x and y , width height contraints for emailSeparator
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        // need x and y , width height contraints for passwordTextfield
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 0).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor).isActive = true
    }
    /**
     Function that sets up loginRegisterButton
     */
     func setupLoginRegisterButton(){
        
        loginRegisterButton.setTitle("Register", for: .normal)
        loginRegisterButton.layer.borderWidth = 1
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        // need x and y , width height contraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
