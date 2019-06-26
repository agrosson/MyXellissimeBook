//
//  Utilities.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 14/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase


/**
 Global properties, functions and extensions for the project
 */

/* Credits photo and icons
 <div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 */


// MARK: - Global properties
/// Current screen height
let screenHeight = UIScreen.main.bounds.height
/// Current screen width
let screenWidth = UIScreen.main.bounds.width
/// This string to be used when user scan a new isbn
var scannedIsbn = ""

// MARK: - Global functions


func setupNavBarWithUser(user: User) -> UIView {
    
    let titleView = UIView()
    titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    titleView.addSubview(containerView)
    
    containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
    
    let profileImageView = UIImageView()
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.layer.cornerRadius = 20
    profileImageView.clipsToBounds = true
    if let profileUrl = user.profileId {
        profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileUrl)
    }
    
    containerView.addSubview(profileImageView)
    // Contraints X Y Width height
    profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    let nameLabel = UILabel()
    nameLabel.text = user.name
    nameLabel.textColor = .white
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(nameLabel)
    // Contraints X Y Width height
    nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
    nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
    
    return titleView
    
}

// MARK: - CustomLabel class
/**
 This class enables to have insets in labels
 */
class CustomLabel: UILabel{
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)))
    }
}

// MARK: - extension UIViewController
extension UIViewController {
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

// MARK: - extension UIImageView

let imageCache = NSCache<AnyObject, AnyObject>()
let coverCache = NSCache<AnyObject, AnyObject>()
/*******************************************************
 This extension manages cache when loading profile images
 ********************************************************/
extension UIImageView {
    /**
     Function that manages uploading images via cache or download storage for profile image
     */
    func loadingImageUsingCacheWithUrlString(urlString : String){
        // first set nil to image to avoid brightness
        self.image = nil
        // Check cache for image : if image already in cache, use this image
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        // If image not in cache, launch download from Firebase and store image recently downloaded in cache to reuse it later
        var download:StorageDownloadTask!
        let storageRef = Storage.storage().reference().child(FirebaseUtilities.shared.profileImage).child("\(urlString).jpg")
        DispatchQueue.main.async {
            download = storageRef.getData(maxSize: 1024*1024*5, completion:  { (data, error) in
                guard let data = data else {
                    print("no data here")
                    return
                }
                if error != nil {
                    print("error here : \(error.debugDescription)")
                }
                print("download succeeded !")
                if let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
                download.resume()
            })
        }
        
    }
    /**
     Function that manages uploading images via cache or download storage for book cover image
     */
    func loadingCoverImageUsingCacheWithisbnString(isbnString : String){
        // first set nil to image to avoid brightness
        self.image = nil
        // Check cache for image : if image already in cache, use this image
        if let cachedImage = coverCache.object(forKey: isbnString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        // If image not in cache, launch download from Firebase and store image recently downloaded in cache to reuse it later
        var download:StorageDownloadTask!
        let storageRef = Storage.storage().reference().child(FirebaseUtilities.shared.coverImage).child("\(isbnString).jpg")
        DispatchQueue.main.async {
            download = storageRef.getData(maxSize: 1024*1024*5, completion:  { (data, error) in
                guard let data = data else {
                    print("no data here")
                    return
                }
                if error != nil {
                    print("error here : \(error.debugDescription)")
                }
                print("download succeeded !")
                if let downloadedImage = UIImage(data: data) {
                    coverCache.setObject(downloadedImage, forKey: isbnString as AnyObject)
                    self.image = downloadedImage
                }
                
                download.resume()
            })
        }
        
    }
}
// MARK: - extension String
/**
 This extension enables to remove inaccurate whitespace
 */
extension String {
    mutating func removeFirstAndLastAndDoubleWhitespace() {
        var newString = self
        repeat {
            if newString.last == " " || newString.last == "\""{
                newString = String(newString.dropLast())
            }
            if newString.first == " " || newString.first == "\""{
                newString = String(newString.dropFirst())
            }
        }
            while newString.first == " " || newString.last == " " || newString.last == "\"" || newString.first == "\""
        repeat { newString = newString.replacingOccurrences(of: "  ", with: " ")
        } while newString.contains("  ")
        self =  newString
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String)-> String {
        guard self.hasSuffix(suffix) else {
            return self
        }
        return String(self.dropLast(suffix.count))
    }
    
}
// MARK: - extension UIColor
/**
 Initializer for UIColor
 */
extension UIColor {
    convenience init(myRed: CGFloat, myGreen: CGFloat, myBlue: CGFloat){
        self.init(red: myRed/255, green: myGreen, blue: myBlue, alpha : 1)
    }
}
