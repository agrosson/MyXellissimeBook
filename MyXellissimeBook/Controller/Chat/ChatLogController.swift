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
    /// ContainerView
    let containerView = CustomUI().view
    /// Image for uploadPhoto
    let origImage = UIImage(named: "uploadPhoto")
    /// TextField to write message
    lazy var inputTextField = CustomUI().textField
    /// Button to upload photo from device
    var uploadImageView = CustomUI().button
    /// Button to send message
    let sendButton = UIButton(type: .system)
    /// Separator
    let separatorView = CustomUI().view
    /// Timer to delay update data in chatlog
    var timerChat: Timer?
    /// Container view anchor
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setInputComponents()
        collectionViewSetup()
        //These notifications to observe behavior of keyboard
        // Show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: - Method - viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Avoid memory leek with this line of code
        NotificationCenter.default.removeObserver(self)
    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - Methods: Objc functions
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
    // MARK: - Methods - override func collectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
         print("on est dans dequeueCell")
        cell.backgroundColor = .clear
        let message = messages[indexPath.row]
        guard let text = message.text else {return UICollectionViewCell()}
        if  text != "" {
            cell.textView.isHidden = false
            cell.textView.text = text
            print("le text existe")
            cell.bubbleWidthAnchor?.constant = estimateFrameFor(text: text).width + 25
            
        } else  {
            print("le text n'existe pas")
          
            if let url = message.messageImageUrl {
            cell.messageImageView.loadingMessageImageUsingCacheWithisString(urlString: url)
            cell.textView.isHidden = true
            cell.bubbleWidthAnchor?.constant = 120
        }
//        if message.text != "" {
//
//        } else {
//
//                 print("on est où tttttt ?")
//            }
        }
        
        setupCell(cell: cell, message: message)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         print("on est dans le collection view size for item ")
        var height: CGFloat = 50
        let width = UIScreen.main.bounds.width
        
        let message = messages[indexPath.row]
       // let url = message.messageImageUrl
        let text = message.text
        guard let imageWidth = message.imageWidth else {return CGSize(width: 0, height: 0)}
        guard let imageHeight = message.imageHeight else {return CGSize(width: 0, height: 0)}
        
        if text != "" {
            print("un texte est présent ")
            guard let textToDisplay = text else {return CGSize(width: 0, height: 0)}
            height = estimateFrameFor(text: textToDisplay).height + 16
            }
         else {
           print("un texte est absent ")
            height = CGFloat(imageHeight/imageWidth * 120)
        }
        return CGSize(width: width, height: height)
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
    
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        // upload profileImage
        if let profileImageUrl = self.user?.profileId {
            cell.profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        // Set the bubble to right if message from current user and hide profileImage
        if message.fromId == Auth.auth().currentUser?.uid {
            // display message in gray bubble
            cell.bubbleView.backgroundColor = .white
            cell.textView.textColor = #colorLiteral(red: 0.3469632864, green: 0.3805449009, blue: 0.4321892262, alpha: 1)
            // Switch bubble from right to left
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            // hide profile image view
            cell.profileImageView.isHidden = true
            
        }
        // Set the bubble to lfet if message not from current user and show profileImage from sender
        else {
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.3469632864, green: 0.3805449009, blue: 0.4321892262, alpha: 1)
            cell.textView.textColor = .white
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            // show profile image view
            cell.profileImageView.isHidden = false
        }
        // upload messageImage if any
        if let messageImageUrl = message.messageImageUrl {
            cell.messageImageView.loadingMessageImageUsingCacheWithisString(urlString: messageImageUrl)
        }
    }
    /**
     Function that fetches message for the user
     */
    private func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let userProfileId = user?.profileId else {return}
        
        let userMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(uid).child(userProfileId)
        userMessageRef.observe(.childAdded, with: { (snapshot) in
            // get the key for the message
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child(FirebaseUtilities.shared.messages).child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                let message = Message(dictionary: dictionary)
                self.messages.append(message)
                // do not forget to reload data here
                DispatchQueue.main.async {self.collectionView.reloadData()}
            }, withCancel: nil)
        }, withCancel: nil)
    }
    /**
     Function that handle cancel
     */
    @objc func handleUploadTap(){
        let picker = UIImagePickerController()
        picker.delegate = self
        // Enable to edit the photo (zoom, resize etc)
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    /**
     function that attempts to reload data
     */
    private func attemptReloadData(){
        self.timerChat?.invalidate()
        self.timerChat = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handlerReloadTable), userInfo: nil, repeats: false)
    }
    /**
     function that reloads data
     */
    @objc func handlerReloadTable(){
        DispatchQueue.main.async {self.collectionView.reloadData()}
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
        inputTextField.resignFirstResponder()
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

extension ChatLogController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /**
     Delegate function get info from picker, get photo
     */
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("we pick a image")
        var selectedImageFromPicker = UIImage()
        // Get edited or originl image from picker
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else {
            guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
            selectedImageFromPicker = originalImage
        }
        let imageAsMessageName = UUID().uuidString
        FirebaseUtilities.saveImageAsMessage(imageAsMessage: selectedImageFromPicker, imageAsMessageName: imageAsMessageName)
        // get the sender Id
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        guard let user = user else {return}
        let height = selectedImageFromPicker.size.height
        let width = selectedImageFromPicker.size.width
        FirebaseUtilities.saveMessageImage(messageImageUrl: imageAsMessageName, fromId: fromId, toUser: user, imageWidth: width, imageHeight: height)
        self.dismiss(animated: true) {
            self.attemptReloadData()
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //DispatchQueue.main.async {self.collectionView.reloadData()}
        self.attemptReloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
}
