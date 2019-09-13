//
//  SearchBookDetailViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - Class SearchBookDetailViewController
/**
 This class defines the SearchBookDetailViewController
 */
class SearchBookDetailViewController: UIViewController {

    /// Book from researche
    var bookToDisplay = Book()
    /// Height for text
    let heightOfText: CGFloat = 20
    /// Current user Uid
    var  currentUid: String  {
        guard let uid = Auth.auth().currentUser?.uid else {return ""}
        return uid
    }
    
    /*******************************************************
     UI variables: Start
     ********************************************************/
    /// Cover of the book
    let bookCoverImageView = CustomUI().imageView
    /// Title label for the book
    let titleLabel = CustomUI().label
    /// Author label for the book
    let authorLabel = CustomUI().label
    /// Container View for the book details
    let containerView = CustomUI().view
    /// SeparateView
    let separateView  = CustomUI().view
    /// Container data Loan details
    let containerDataView = CustomUI().view
    /// Reminder label
    var reminderLabel = CustomUI().label
    /// Button send message
    let buttonSendMessage = CustomUI().button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        containerView.addSubview(bookCoverImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(authorLabel)
        containerView.addSubview(separateView)
        view.addSubview(containerDataView)
        containerDataView.addSubview(reminderLabel)
        containerDataView.addSubview(buttonSendMessage)
        setupUIObjects()
        setupScreen()
    }
    
    /**
     Function that sets up customUI objects
     */
    private func setupUIObjects(){
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        separateView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        guard let uniqueId = bookToDisplay.uniqueId else {return}
        guard let isbn = bookToDisplay.isbn else {return}
        let ownerId = uniqueId.deletingSuffix(isbn)
        reminderLabel.numberOfLines = 0
        FirebaseUtilities.getUserNameFromUserId(userId: ownerId, callBack: { (name) in
            guard let name = name else {return}
            self.reminderLabel.text = "This book belongs to \(name). You can send a message to borrow the book"
        })
    }
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        if let isbn = bookToDisplay.isbn {
            bookCoverImageView.loadingCoverImageUsingCacheWithisbnString(isbnString: isbn)
        }
        setupBookCoverImageView()
        setupTitleLabel()
        setupAuthorLabel()
        setupContainerView()
        setupSeparateView()
        setupContainerDataView()
        setupReminderLabel()
        setupbuttonSendMessage()

    }
    /**
     Function that sets up showUserBooksLentButton
     */
    private func setupbuttonSendMessage(){
        buttonSendMessage.setTitle("Send a message", for: .normal)
        buttonSendMessage.layer.cornerRadius = 15
        buttonSendMessage.titleLabel?.font = .systemFont(ofSize: 30)
        buttonSendMessage.addTarget(self, action: #selector(popChatViewController), for: .touchUpInside)
        // need x and y , width height contraints
        buttonSendMessage.leftAnchor.constraint(equalTo: containerDataView.leftAnchor, constant: 8).isActive = true
        buttonSendMessage.rightAnchor.constraint(equalTo: containerDataView.rightAnchor, constant: -8).isActive = true
        buttonSendMessage.topAnchor.constraint(equalTo: reminderLabel.bottomAnchor, constant: 20).isActive = true
        buttonSendMessage.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    /**
     Function that opens ChatLogController after having retrieved user from profileId
     */
    @objc func popChatViewController(){
        guard let uniqueId = bookToDisplay.uniqueId else {return}
        guard let isbn = bookToDisplay.isbn else {return}
        let ownerId = uniqueId.deletingSuffix(isbn)
        FirebaseUtilities.getUserFromProfileId(profileId: ownerId) { user in
             self.showChatControllerForUser(user: user)
        }
    }
    
    /**
     Function that presents chatLogController
     */
    func showChatControllerForUser(user: User){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }

}
