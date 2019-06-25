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

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // As soon as set, the navigationItem.title is updated
    /// User logged in
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    /// Id of cell of the Collection view
    var cellId = "cellId"
    
    /// Array of all messages
    var messages = [Message]()
    /// Dictionary of last messages by users
    var messagesDictionary = [String: Message]()
    
    /// TextField to write message
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
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setInputComponents()
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
        
        setupKeyboardObserver()
        
        //These notification to observe behavior of keyboard
        // Show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Methods
    /**
     Function that modifies containerViewBottomAnchor to lift the textField with keyboard
     */
    @objc func handldeKeyboardWillShow(notification : NSNotification){
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        let safeLayoutGuideBot = self.view.safeAreaInsets.bottom
        let height =  (keyboardFrame?.height)! - safeLayoutGuideBot
        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else {return}
        containerViewBottomAnchor?.constant = -height - tabbarHeight
        
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
        
    }
    /**
     Function that modifes containerViewBottomAnchor to set down the textField with keyboard
     */
    @objc func handldeKeyboardWillHide(notification : NSNotification){

        guard let tabbarHeight = self.tabBarController?.tabBar.frame.height else {return}
        containerViewBottomAnchor?.constant = -tabbarHeight
    }
    
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupKeyboardObserver(){
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let text = messages[indexPath.row].text else {
            return CGSize(width: 0, height: 0)
        }
        let height: CGFloat = estimateFrameFor(text: text).height + 16
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    
    // MARK: - Methods
    /**
     Function that returns a estimated CGRect given a String
     - Parameter text: String embeded
     - Returns: the CGRect that embeds the string
     */
    private func estimateFrameFor(text : String) -> CGRect {
        let width = 3*UIScreen.main.bounds.width/4
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        // this attribute (NSAttributedString.Key.font)  is necessary
        return  NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], context: nil)
        
    }
    // MARK: - Methods - override func collectionView
    /*******************************************************
     override func collectionView
     ********************************************************/
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.backgroundColor = .clear
        let message = messages[indexPath.row]
        guard let text = message.text else {return UICollectionViewCell()}
        cell.textView.text = text
        
        
        setupCell(cell: cell, message: message)
        
        
        cell.bubbleWidthAnchor?.constant = estimateFrameFor(text: text).width + 25
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileId {
            cell.profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            // display message in gray bubble
            cell.bubbleView.backgroundColor = .white
            cell.textView.textColor = #colorLiteral(red: 0.3469632864, green: 0.3805449009, blue: 0.4321892262, alpha: 1)
            // Switch bubble from right to left
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            // hide profile image view
            cell.profileImageView.isHidden = true
            
        } else {
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.3469632864, green: 0.3805449009, blue: 0.4321892262, alpha: 1)
            cell.textView.textColor = .white
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            // show profile image view
            cell.profileImageView.isHidden = false
        }
    }
    /**
     Function that fetches message for the user
     */
    private func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(uid)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            // get the key for the message
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child(FirebaseUtilities.shared.messages).child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                let message = Message()
                guard let fromId = dictionary["fromId"] as? String else {return}
                guard let toId =  dictionary["toId"] as? String else {return}
                guard let text =  dictionary["text"] as? String else {return}
                guard let timestamp =  dictionary["timestamp"] as? Int else {return}
                message.fromId = fromId
                message.timestamp = timestamp
                message.toId = toId
                message.text = text
                // we only show the message concerning the user
                if message.chatPartnerId() ==  self.user?.profileId {
                    self.messages.append(message)
                    // do not forget to reload data here
                    DispatchQueue.main.async {self.collectionView.reloadData()}
                }
                
            }, withCancel: nil)
            
            
        }, withCancel: nil)
        
    }
    /**
     Function that setup layout of container for writing
     */
    private func setInputComponents(){
        
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
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabbarHeight)
        containerViewBottomAnchor?.isActive = true
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
        // need x and y , width height contraints
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        gestureTapCreation()
        gestureswipeCreation()
    }
    /**
     Function that handle cancel
     */
    @objc private func handelCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    /**
     Function that handle send message
     
     A message will be stored in the node "messages" with a specific id (childRef = ref.childByAutoId())
     
     This reference will be then stored in other places in the node "user-messages"
     - one to identify the sender : child(fromId)
     - one to identify the recipeint : child(toId)
     */
    @objc func handleSend(){
        
        // this block to save messages
        guard var text = inputTextField.text else {return}
        text.removeFirstAndLastAndDoubleWhitespace()
        // get the sender Id
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        
        guard let user = user else {return}
        if !text.isEmpty {
              FirebaseUtilities.saveMessage(text: text, fromId : fromId, toUser: user)
        }
        // reset the textField
        self.inputTextField.text = nil
        
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
        // Question : is it accurate to dismiss the VC after sending message ?
        return true
    }
    
}
