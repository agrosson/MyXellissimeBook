//
//  CustomUI.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//


// MARK: - class ChatMessageCell
/**
 This class defines ChatMessage customized cell
 */
import UIKit


class CustomUI {
    
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Customized UIImageView
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var button : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    var view : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = UIKeyboardType.default
        textField.textColor = UIColor.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
}
