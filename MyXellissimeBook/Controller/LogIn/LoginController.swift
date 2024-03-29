//
//  LoginController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

// MARK: - Class LoginController
/**
 This class defines the Login ViewController
 */
class LoginController: UIViewController {
    // MARK: - Outlets and properties
    var initialViewController: InitialViewController?
    /// Container View for inputs during registration
    let inputsContainerView = CustomUI().view
    /// Register Button
    lazy var loginRegisterButton = CustomUI().button
    /// Reset Password Button
    lazy var resetPasswordButton = CustomUI().button
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
        let segment = UISegmentedControl(items: ["Se connecter","S'inscrire"])
        segment.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        segment.selectedSegmentIndex = 0
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
    /// loginRegisterButtonYAnchor
    var inputsContainerViewYAnchor: NSLayoutConstraint?
    
    
    // Show battery image in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        view.addSubview(profileImageView)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisteredSegmentedControl)
        view.addSubview(resetPasswordButton)
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .oneTimeCode
        }
        setupScreen()
        perform(#selector(changePhoto), with: nil, afterDelay: 0.5)
        manageObservers()
        
    }
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manageObservers()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DatabaseReference().removeAllObservers()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Methods
    /**
     Function that manages observers for keyboards
     */
    private func manageObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    // MARK: - Methods: Objc functions
    /**
     Function that modifies containerViewBottomAnchor to lift the textField with keyboard
     */
    @objc func handldeKeyboardDidShow(){
        NotificationCenter.default.removeObserver(self)
        manageObservers()
    }
    /**
     Function that modifies containerViewBottomAnchor to lift the textField with keyboard
     */
    @objc func handldeKeyboardWillShow(notification : NSNotification){
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        let height: CGFloat =  screenHeight > 600 ? 70 : 200
        inputsContainerViewYAnchor?.constant = -height
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    /**
     Function that modifes containerViewBottomAnchor to set down the textField with keyboard
     */
    @objc func handldeKeyboardWillHide(notification : NSNotification){
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        inputsContainerViewYAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    /**
     Function that setup screen
     */
    private func setupScreen(){
       
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        setupInputsContrainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setuploginRegisteredSegmentedControl()
        setupResetPasswordButton()
        manageTextField()
        gestureTapCreation()
        gestureswipeCreation()
        toggleSegment()
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
    /**
     Function that displays a alert to propose to change profile image
     */
    @objc func changePhoto() {
        Alert.shared.controller = self
        Alert.shared.alertDisplay = .updateProfileImage
    }
    
    private func checkIfProfileImageShouldBeUpdated() {
        let actionSheet = UIAlertController(title: "Cher utilisateur", message: "Doit-on mettre à jour la photo du profil avec l'image actuelle?", preferredStyle: .alert)
        actionSheet.addAction(UIAlertAction(title: "Oui", style: .default, handler: { (action: UIAlertAction) in
            print("update the picture")
            self.handleLoginWithProfileUpdate(update: true)
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Non", style: .default, handler: { (action: UIAlertAction) in
            self.handleLoginWithProfileUpdate(update: false)
        }))
        actionSheet.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
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

