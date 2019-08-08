//
//  ChatMessageCell.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 18/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - class ChatMessageCell
/**
 This class defines ChatMessage customized cell
 */
class ChatMessageCell: UICollectionViewCell {
    /*******************************************************
                        UI variables: Start
     ********************************************************/
    // MARK: - Properties UIViews
    /// TextView that will display the message text, embeded in the bubbleView
    let textView = CustomUI().textView
    /// UIView that embeds the text
    let bubbleView = CustomUI().view
    /// UIImageView that display partner chat profile image
    let profileImageView = CustomUI().imageView
    /// UIImageView that display a image if any
    let messageImageView = CustomUI().imageView
    
    /*******************************************************
                        UI variables: End
     ********************************************************/
    // MARK: - Properties
    /// NSLayoutConstraint that enables to adapt size of bubbleView
    var bubbleWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(bubbleView)
        addSubview(profileImageView)
        addSubview(textView)
        bubbleView.addSubview(messageImageView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    /**
     Function that sets up views' setupConstraints
     */
    private func setupConstraints(){
        let width = 3*UIScreen.main.bounds.width/4
        // Contraints X Y Width height
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        // Contraints X Y Width height
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        // as property is false by default, not need to specify that
        // bubbleViewLeftAnchor?.isActive = false
        bubbleView.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: width)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Constraints of messageImageView
        messageImageView.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
 
        
        // Contraints X Y Width height : textview is embeded in bubble with left and right anchor
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
