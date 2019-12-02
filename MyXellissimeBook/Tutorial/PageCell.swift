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
            guard let unwrappedPage = page else { return }
            screenshotImage.image = UIImage(named: unwrappedPage.imageName)
            let attributedTextHeader = NSMutableAttributedString(string: unwrappedPage.headerText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)])
            let attributedTextBody = NSMutableAttributedString(string: unwrappedPage.bodyText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.gray])
            descriptionHeaderTextView.attributedText = attributedTextHeader
            descriptionHeaderTextView.textAlignment = .center
            descriptionBodyTextView.attributedText = attributedTextBody
            descriptionBodyTextView.textAlignment = .left
        }
    }
    
    private let screenshotImage: UIImageView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    private func setupLayout() {
        let topImageContainerView = UIView()
        addSubviews(topImageContainerView,descriptionTextViewContainer)
        topImageContainerView.addSubview(screenshotImage)
        descriptionTextViewContainer.addSubviews(descriptionHeaderTextView,descriptionBodyTextView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
         topImageContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
         topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
         topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
         screenshotImage.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
         screenshotImage.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
         screenshotImage.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.85),
         topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.70, constant: -120),
         descriptionTextViewContainer.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
         descriptionTextViewContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
         descriptionTextViewContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
         descriptionTextViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
         descriptionHeaderTextView.topAnchor.constraint(equalTo: descriptionTextViewContainer.topAnchor),
         descriptionHeaderTextView.leftAnchor.constraint(equalTo: descriptionTextViewContainer.leftAnchor),
         descriptionHeaderTextView.rightAnchor.constraint(equalTo: descriptionTextViewContainer.rightAnchor),
         descriptionHeaderTextView.heightAnchor.constraint(equalTo: descriptionTextViewContainer.heightAnchor, multiplier: 0.3),
         descriptionBodyTextView.topAnchor.constraint(equalTo: descriptionHeaderTextView.bottomAnchor),
         descriptionBodyTextView.leftAnchor.constraint(equalTo: descriptionTextViewContainer.leftAnchor),
         descriptionBodyTextView.rightAnchor.constraint(equalTo: descriptionTextViewContainer.rightAnchor),
         descriptionBodyTextView.heightAnchor.constraint(equalTo: descriptionTextViewContainer.heightAnchor, multiplier: 0.7),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
