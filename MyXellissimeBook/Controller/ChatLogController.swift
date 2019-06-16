//
//  ChatLogController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 15/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatLogController: UICollectionViewController {
    
    var user: User?
    
    lazy var inputTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your message"
        textField.textColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setInputComponents()
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let name = user?.name else {return}
        navigationItem.title = name
    }
    
    func setInputComponents(){
        
        // create the container
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
            // do not forget
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        // need x and y , width height contraints
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else {return}
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabbarHeight).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // create the send button
        /// Send Button
        let sendButton = UIButton(type: .system)
        sendButton.tintColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        // need x and y , width height contraints
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        // create the textField
        /// textField
        containerView.addSubview(inputTextField)
        // need x and y , width height contraints
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        // create the separator
        /// separator
        let separatorView = UIView()
        separatorView.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    /**
     Function that setup screen
     */
    private func setupScreen(){
        collectionView.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationItem.title = "ChatLog for \(InitialViewController.titleName)"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        gestureTapCreation()
        gestureswipeCreation()
    }
    
    @objc private func handelCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleSend(){
        guard let text = inputTextField.text else {return}
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let values = ["text" : text]
        childRef.updateChildValues(values)
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
        inputTextField.delegate = self
    }
    /**
     Action for tap and Swipe Gesture Recognizer
     */
    @objc private func myTap() {
        inputTextField.resignFirstResponder()
        
    }
}

extension ChatLogController : UITextFieldDelegate {
    
    /**
     UITextFieldDelegate : defines how textFieldShouldReturn
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        inputTextField.resignFirstResponder()
        return true
    }

}
