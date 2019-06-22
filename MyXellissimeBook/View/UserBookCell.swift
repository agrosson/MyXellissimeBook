//
//  UserBookCell.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 21/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - class UserBookCell
/**
 This class defines UserBookCell customized cell
 */
class UserBookCell: UITableViewCell {
    // MARK: - Properties
    /** book object:
     when this variable is set, it executes the block to fill the cell with accurate data
     */
    var book: Book? {
        didSet{
            setupTitleAndAuthorAndEditorAndCoverImage()
        }
    }
    /*******************************************************
                     UI variables: Start
     ********************************************************/
    // MARK: - Properties UIViews
    /// ImageView that is used to display book cover image
    let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profileDefault")
        imageView.contentMode = .scaleAspectFit
        // imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    /// ImageView that is used to display if book is available or not
    let availabilityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.layer.masksToBounds = true
        return imageView
    }()
    /*******************************************************
                       UI variables: End
     ********************************************************/
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        // add the profile image
        addSubview(coverImageView)
        addSubview(availabilityImageView)
        setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Methods
    /**
     Function that sets up views' constraints
     */
    private func setupConstraints(){
        // Contraints X Y Width height
        coverImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        coverImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        coverImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // Contraints X Y Width height
        availabilityImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        availabilityImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        availabilityImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        availabilityImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    /**
     Function that configures the cell with book's attributes
     */
    private func setupTitleAndAuthorAndEditorAndCoverImage(){
        textLabel?.text = book?.title
        detailTextLabel?.text = book?.author
        coverImageView.loadingCoverImageUsingCacheWithisbnString(isbnString: book?.isbn ?? "profileDefault.jpg")
        backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .white
        if  book?.isAvailable == true {
            availabilityImageView.image = UIImage(named: "greenButton")
        } else {
            availabilityImageView.image = UIImage(named: "redButton")
        }
    }
    /**
     Function that rearranges the layout of the cell to push labels on the right (x = 76)
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 76, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 76, y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
}
