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
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16) //  tv.font = UIFont.systemFont(ofSize: 18)
        tv.textColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        // White by default : careful to make it clear
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    /// UIView that embeds the text
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9092954993, green: 0.865521729, blue: 0.8485594392, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /*******************************************************
                        UI variables: End
     ********************************************************/
    // MARK: - Properties
    /// NSLayoutConstraint that enables to adapt size of bubbleView
    var bubbleWidthAnchor : NSLayoutConstraint?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(bubbleView)
        addSubview(textView)
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
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: width)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        // Contraints X Y Width height : textview is embeded in bubble with left and right anchor
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 5).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
}
