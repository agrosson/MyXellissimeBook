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
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // do not forget
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()
    // create button
    /// Register Button
    lazy var loginRegisterButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    /// TextField to get user name
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.keyboardType = UIKeyboardType.default
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 1
        return textField
    }()
    /// View as a separator between textField
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// TextField to get user email
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email address"
        textField.keyboardType = UIKeyboardType.default
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 2
        
        return textField
    }()
    /// View as a separator between textField
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// TextField to get user password
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        // protect the text
        // todo: see the problem with keyboard azerty
        textField.isSecureTextEntry = true
        textField.keyboardType = UIKeyboardType.default
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tag = 3
        
        return textField
    }()
    /// ImageView to display user image/picture
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileDefault")
        //scaleToFit = enlarges the image to much
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImage)))
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
    /**
     Function that sets up setuploginRegisteredSegmentedControl
     */
    private func setuploginRegisteredSegmentedControl(){
        // need x and y , width height contraints
        loginRegisteredSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisteredSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisteredSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisteredSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    /**
     Function that sets up profileImageView
     */
    private func setupProfileImageView(){
        // need x and y , width height contraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisteredSegmentedControl.topAnchor, constant: -12).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    /**
     Function that sets up inputsContainerView
     */
    private func setupInputsContrainerView(){
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
    private func setupLoginRegisterButton(){
        // need x and y , width height contraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    /**
     Function that handles Login
     */
    private func handleLogin(){
        // Get info from textField
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            //Todo an alert to be done
            print("Should create an alert because loggin items not completed")
            return
        }
        // Connect to Firebase Auth
        Auth.auth().signIn(withEmail: email, password: password) { (resultSignIn, errorSignIn) in
            if errorSignIn != nil {
                print("Should create an alert because loggin items are false")
                return
            }
            /*************************
             update the title of the initialVC with new name
             **************************/
            if let uid = Auth.auth().currentUser?.uid {
                self.saveProfileImageForUser(uid:uid )
            }
            self.initialViewController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
            print("\(email) has been  successfully logged in !")
        }
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
    @objc private func handleLoginRegister() {
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .oneTimeCode
        }
        if loginRegisteredSegmentedControl.selectedSegmentIndex == 0 {
            
            handleLogin()
        } else {
            handleRegister()
        }
    }
}
// MARK: - Extensions
/**
 Initializer for UIColor
 */
extension UIColor {
    convenience init(myRed: CGFloat, myGreen: CGFloat, myBlue: CGFloat){
        self.init(red: myRed/255, green: myGreen, blue: myBlue, alpha : 1)
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

