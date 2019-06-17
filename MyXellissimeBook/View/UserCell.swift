//
//  UserCell.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 14/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    /****************************************************************************************
     When this variable is set, it executes the block to fill the cell with accurate data
     *****************************************************************************************/
    var messageUserCell: Message? {
        didSet{
            
            if let toId = messageUserCell?.toId {
                let ref = Database.database().reference().child("users").child(toId)
                ref.observeSingleEvent(of: .value, with: { (snapShot) in
                    print(snapShot)
                    
                    if let dictionary = snapShot.value as? [String : Any] {
                        self.textLabel?.text = dictionary["name"] as? String
                        if let profileImageURL = dictionary["profileImageURL"] as? String {
                            self.profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileImageURL)
                        }
                    }
                }, withCancel: nil)
            }
 
            backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
            textLabel?.textColor = .white
            detailTextLabel?.textColor = .white
            detailTextLabel?.text = messageUserCell?.text
        }
    }

    // ImageView that is added to the .title cell
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profileDefault")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()
     // timestamp that is added to the .title cell
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "hh:mm:ss"
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        // add the profile image
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        // Contraints X Y Width height
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Contraints X Y Width height
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: textLabel!.heightAnchor).isActive = true
        
        
    }
        // rearrange the layout of the cell to push labels on the right (x = 76)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 76, y: (textLabel?.frame.origin.y)!, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 76, y: (detailTextLabel?.frame.origin.y)!, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
