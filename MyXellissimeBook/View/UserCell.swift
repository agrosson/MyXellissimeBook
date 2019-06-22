//
//  UserCell.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 14/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase



// MARK: - class class UserCell
/**
 This class defines UserCell customized cell
 */
class UserCell: UITableViewCell {
    /****************************************************************************************
     When this variable is set, it executes the block to fill the cell with accurate data
     *****************************************************************************************/
    // MARK: - Properties
    /** Message object:
     when this variable is set, it executes the block to fill the cell with accurate data
    */
    var message: Message? {
        didSet{
            setupNameAndImageProfile()
        }
    }
    
    /*******************************************************
     UI variables: Start
     ********************************************************/
    // MARK: - Properties UIViews
    /// ImageView that is used to display profile image
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profileDefault")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()
    /// Timestamp that is displayed in the cell
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    /*******************************************************
     UI variables: End
     ********************************************************/
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        // add the profile image
        addSubview(profileImageView)
        addSubview(timeLabel)
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
        // Contraints X Y Width height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Contraints X Y Width height
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
    }
    /**
     Function that sets up the name and the image profile
    
     When message is displayed, the profile image shown is the partner profile and not the user.
     1. Get the partner id
     2. Get profile of partner
     3. Display profile
     */
    private func setupNameAndImageProfile() {
        // 1. Get the partner id of the chat
        let chatPartnerId: String?
        if message?.fromId == Auth.auth().currentUser?.uid {
            chatPartnerId = message?.toId
        } else {
            chatPartnerId = message?.fromId
        }
        // 2. Get profile of partner
        if let idToUse = chatPartnerId {
            let ref = Database.database().reference().child("users").child(idToUse)
            ref.observeSingleEvent(of: .value, with: { (snapShot) in
                print(snapShot)
                if let dictionary = snapShot.value as? [String : Any] {
                    // 3. Display profile
                    self.textLabel?.text = dictionary["name"] as? String
                    if let profileId = dictionary["profileId"] as? String {
                        self.profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileId)
                    }
                }
            }, withCancel: nil)
        }
        backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        textLabel?.textColor = .white
        detailTextLabel?.textColor = .white
        detailTextLabel?.text = message?.text
        if let seconds = message?.timestamp {
            let time = Date(timeIntervalSince1970: TimeInterval(seconds))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            // other format "yyyy-MM-dd'T'HH:mm:ssZ"
            timeLabel.text = dateFormatter.string(from: time)
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
