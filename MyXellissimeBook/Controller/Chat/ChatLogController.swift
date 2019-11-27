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

// MARK: - Class ChatLogController
/**
 This class defines the ChatLogController
 */
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
    /// RefreshControl
    var refreshController = UIRefreshControl()
    /// CGRect used to define frame of photo message
    var startingFrame: CGRect?
    /// UIView to display behind photo or image when zoom in
    var blackView = UIView()
    /// UIImageView
    var startingImageView = UIImageView()
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setInputComponents()
        collectionViewSetup()
        manageObservers()
        addRefreshControl()
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
        manageObservers()
    }
    // MARK: - Methods
    /**
     Function that setup screen
     */
    private func setupScreen(){
        collectionView.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: navigationItemColor]
        gestureTapCreation()
        gestureswipeCreation()
        inputTextField.delegate = self
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
     Function that adds and defines refresh control for collection view
     */
    fileprivate func addRefreshControl() {
        let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white]
        refreshController.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes )
        refreshController.tintColor = .white
        refreshController.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshController)
    }
    /**
     Function that manages observers for keyboards
     */
    private func manageObservers() {
        // show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // hide keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handldeKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    /**
     Function that returns a estimated CGRect given a String
     - Parameter text: String embeded
     - Returns: the CGRect that embeds the string
     */
    func estimateFrameFor(text : String) -> CGRect {
        let width = 3*UIScreen.main.bounds.width/4
        let size = CGSize(width: width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        // this attribute (NSAttributedString.Key.font)  is necessary
        return  NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)], context: nil)
    }
    /**
     Function that setups the cell with
     - Parameter cell: The  cell in which to display the message
     - Parameter message: The Message to display
     */
    func setupCell(cell: ChatMessageCell, message: Message) {
        // upload profileImage
        if let profileImageUrl = self.user?.profileId {
            cell.profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        // Set the bubble to right if message from current user and hide profileImage
        if message.fromId == Auth.auth().currentUser?.uid {
            cell.messageImageView.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
            cell.textView.textColor = #colorLiteral(red: 0.3469632864, green: 0.3805449009, blue: 0.4321892262, alpha: 1)
            // Switch bubble from right to left
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            // hide profile image view
            cell.profileImageView.isHidden = true
        }
            // Set the bubble to left if message not from current user and show profileImage from sender
        else {
            cell.messageImageView.backgroundColor = #colorLiteral(red: 0.3469632864, green: 0.3805449009, blue: 0.4321892262, alpha: 1)
            cell.textView.textColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
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
                DispatchQueue.main.async {self.attemptReloadData()                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    /**
     Function that handles cancel
     */
    @objc func handleUploadTap(){
        let picker = UIImagePickerController()
        picker.delegate = self
        // Enable to edit the photo (zoom, resize etc)
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    /**
     Function that attempts to reload data
     */
    func attemptReloadData(){
        self.timerChat?.invalidate()
        self.timerChat = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.handlerReloadTable), userInfo: nil, repeats: false)
    }
    /**
     Function that reloads data
     */
    @objc func handlerReloadTable(){
        DispatchQueue.main.async {self.collectionView.reloadData()
            let indexPath = IndexPath(item: self.messages.count-1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    /**
     Function that handle cancel
     */
    @objc private func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    /**
    Function that tests if message has been written from search book : if so, you have to pop the view in order to come back to search option
    */
    @objc func testIfMessageFromSearch() {
        if messageFromSearch == true {
            messageFromSearch = false
            navigationController?.popViewController(animated: true)
        }
    }
    /**
     Function that handles sent message
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
        perform(#selector(testIfMessageFromSearch), with: nil, afterDelay: 1)
    }
    // MARK: - Methods: Objc functions
    /**
     Function that scrolls donw to show last message when keyboard disapears
     */
    @objc func handldeKeyboardDidShow(){
        if messages.count > 0 {
            let indexpath = IndexPath(item: messages.count-1, section: 0)
            collectionView.scrollToItem(at: indexpath, at: .top, animated: true)
        }
        NotificationCenter.default.removeObserver(self)
        manageObservers()
    }
    /**
     Function that refreshes collection View
     */
    @objc func refresh() {
        attemptReloadData()
        self.refreshController.endRefreshing()
    }
    /**
     Function that modifies containerViewBottomAnchor to lift the textField with keyboard
     */
    @objc func handldeKeyboardWillShow(notification : NSNotification){
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        var safeLayoutGuideBottom: CGFloat = 0
        if #available(iOS 11.0, *) {
            safeLayoutGuideBottom = self.view.safeAreaInsets.bottom
        }
        let height =  (keyboardFrame?.height)! - safeLayoutGuideBottom
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
    /**
     Action for tap and Swipe Gesture Recognizer
     */
    @objc private func myTap() {
        inputTextField.resignFirstResponder()
    }
}
