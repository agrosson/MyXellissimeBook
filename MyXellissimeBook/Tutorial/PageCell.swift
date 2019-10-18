//
//  PageCell.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 18/10/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

class PageCell: UICollectionViewCell {
    
    var page: Page? {
        didSet {
//            print(page?.imageName)
            
            guard let unwrappedPage = page else { return }
            
            bearImageView.image = UIImage(named: unwrappedPage.imageName)
            
            let attributedTextHeader = NSMutableAttributedString(string: unwrappedPage.headerText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
            let attributedTextBody = NSMutableAttributedString(string: unwrappedPage.bodyText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.gray])
            
            descriptionHeaderTextView.attributedText = attributedTextHeader
            descriptionHeaderTextView.textAlignment = .center
            descriptionBodyTextView.attributedText = attributedTextBody
            descriptionBodyTextView.textAlignment = .left
        }
    }
    
    private let bearImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bookAtLaunchScreen"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionHeaderTextView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
     
        label.numberOfLines = 0
         label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    private let descriptionBodyTextView: UILabel = {
              let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
       
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    private let descriptionTextViewContainer: UIView = {
        let view = UIView()
      
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private let descriptionTextView: UITextView = {
//        let textView = UITextView()
//
//        let attributedText = NSMutableAttributedString(string: "Join us today in our fun and games!", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 25)])
//
//        attributedText.append(NSAttributedString(string: "\n\n\nAre you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our stores soon.", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor: UIColor.gray]))
//
//        textView.attributedText = attributedText
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.textAlignment = .center
//        textView.isEditable = false
//        textView.isScrollEnabled = false
//        return textView
//    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    private func setupLayout() {
        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
     
        topImageContainerView.addSubview(bearImageView)
        bearImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        bearImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        bearImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.85).isActive = true
        
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.70, constant: -120).isActive = true
        
        addSubview(descriptionTextViewContainer)
        
        descriptionTextViewContainer.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        descriptionTextViewContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        descriptionTextViewContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        descriptionTextViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120).isActive = true
       
        descriptionTextViewContainer.addSubview(descriptionHeaderTextView)
        descriptionTextViewContainer.addSubview(descriptionBodyTextView)
        
        descriptionHeaderTextView.topAnchor.constraint(equalTo: descriptionTextViewContainer.topAnchor).isActive = true
        descriptionHeaderTextView.leftAnchor.constraint(equalTo: descriptionTextViewContainer.leftAnchor).isActive = true
        descriptionHeaderTextView.rightAnchor.constraint(equalTo: descriptionTextViewContainer.rightAnchor).isActive = true
        descriptionHeaderTextView.heightAnchor.constraint(equalTo: descriptionTextViewContainer.heightAnchor, multiplier: 0.3).isActive = true
        
        descriptionBodyTextView.topAnchor.constraint(equalTo: descriptionHeaderTextView.bottomAnchor).isActive = true
        descriptionBodyTextView.leftAnchor.constraint(equalTo: descriptionTextViewContainer.leftAnchor).isActive = true
        descriptionBodyTextView.rightAnchor.constraint(equalTo: descriptionTextViewContainer.rightAnchor).isActive = true
        descriptionBodyTextView.heightAnchor.constraint(equalTo: descriptionTextViewContainer.heightAnchor, multiplier: 0.7).isActive = true

        /*
         addSubview(descriptionTextView)
         descriptionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
         descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
         descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
         descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120).isActive = true
         */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
