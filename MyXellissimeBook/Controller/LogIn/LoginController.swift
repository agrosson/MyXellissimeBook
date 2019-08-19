//
//  LoginController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Class LoginController
/**
 This class defines the Login ViewController
 */
class LoginController: UIViewController {
    
    var initialViewController: InitialViewController?
    
    // MARK: - Outlets and properties
    /// Container View for inputs during registration
    let inputsContainerView = CustomUI().view
        
    // create button
    /// Register Button
    lazy var loginRegisterButton = CustomUI().button
    
    /// TextField to get user name
    let nameTextField = CustomUI().textField

    /// View as a separator between textField
    let nameSeparatorView = CustomUI().view
    
    /// TextField to get user email
    let emailTextField = CustomUI().textField

    /// View as a separator between textField
    let emailSeparatorView = CustomUI().view
    
    /// TextField to get user password
    let passwordTextField = CustomUI().textField
        
    /// ImageView to display user image/picture
    lazy var profileImageView = CustomUI().imageView

    /// SegmentedControl to switch from Login/Register
    lazy var loginRegisteredSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Login","Register"])
        segment.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        segment.selectedSegmentIndex = 1
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget(self, action: #selector(toggleSegment), for: .valueChanged)
        return segment
    }()
    
    /// Height constraint of the input container
    var inputsContainerViewHeightConstraint: NSLayoutConstraint?
    /// Height constraint of the nametextfied
    var nameTextFieldViewHeightConstraint: NSLayoutConstraint?
    /// Height constraint of the emailTextField
    var emailTextFieldViewHeightConstraint: NSLayoutConstraint?
    /// Height constraint of the passwordTextField
    var passwordTextFieldViewHeightConstraint: NSLayoutConstraint?
    /// Height constraint of the passwordTextField
    var nameSeperatorTextFieldViewHeightConstraint: NSLayoutConstraint?
    // Show battery image in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profileImageView)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisteredSegmentedControl)
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .oneTimeCode
        }
        setupScreen()
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - Methods
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        setupInputsContrainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setuploginRegisteredSegmentedControl()
        manageTextField()
        gestureTapCreation()
        gestureswipeCreation()
    }
    /**
     Function that creates a tap Gesture Recognizer
     */
    private func gestureTapCreation() {
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myTap
            ))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(mytapGestureRecognizer)
    }
    /**
     Function that creates a Swipe Gesture Recognizer
     */
    private func gestureswipeCreation() {
        let mySwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(myTap
            ))
        mySwipeGestureRecognizer.direction = .down
        self.view.addGestureRecognizer(mySwipeGestureRecognizer)
    }
    /**
     Function that manages TextField
     */
    
    private func manageTextField() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
   
    // MARK: - Method  - Actions with objc functions
    /**
     Action for switch segmented control
     */
    @objc private func toggleSegment(){
        let title = loginRegisteredSegmentedControl.titleForSegment(at: loginRegisteredSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        // change height of container
        inputsContainerViewHeightConstraint?.isActive = false
        inputsContainerViewHeightConstraint?.constant = loginRegisteredSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        inputsContainerViewHeightConstraint?.isActive = true
        
        // change height of name textField
        nameTextFieldViewHeightConstraint?.isActive = false
        nameTextFieldViewHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisteredSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldViewHeightConstraint?.isActive = true
        
        // change height of Email textfield
        emailTextFieldViewHeightConstraint?.isActive = false
        emailTextFieldViewHeightConstraint = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisteredSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldViewHeightConstraint?.isActive = true
        
        // change height of name separator
        nameSeperatorTextFieldViewHeightConstraint?.isActive = false
        nameSeperatorTextFieldViewHeightConstraint?.constant = loginRegisteredSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1
        nameSeperatorTextFieldViewHeightConstraint?.isActive = true
    }
    /**
     Action for tap and Swipe Gesture Recognizer
     */
    @objc private func myTap() {
        nameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    /**
     Function that handles Registration/Login
     Switch on function depending on segmented item selected
     */
    @objc func handleLoginRegister() {
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .oneTimeCode
        }
        if loginRegisteredSegmentedControl.selectedSegmentIndex == 0 {
            guard var email = emailTextField.text, var password = passwordTextField.text else {
                //Todo an alert to be done
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .needAllFieldsCompleted
                return
            }
            email.removeFirstAndLastAndDoubleWhitespace()
            password.removeFirstAndLastAndDoubleWhitespace()
            
            if email.isEmpty || password.isEmpty {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .needAllFieldsCompleted
                return
            }
            if !isValidEmail(testStr: email) {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .emailBadlyFormatted
                return
            }
            if password.count < 6 {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .passwordIsTooShort
                return
            }
            checkIfProfileImageShouldBeUpdated()
        } else {
            handleRegister()
        }
    }
    
    private func checkIfProfileImageShouldBeUpdated() {
        let actionSheet = UIAlertController(title: "Dear user", message: "Should we update profile image with current picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction) in
            print("update the picture")
            self.handleLoginWithProfileUpdate(update: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction) in
            self.handleLoginWithProfileUpdate(update: false)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion : nil)
    }
    
}

// MARK: - Extensions   UITextFieldDelegate
extension LoginController: UITextFieldDelegate {
    /**
     UITextFieldDelegate : defines how textFieldShouldReturn
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag != 3 {
            self.view.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

