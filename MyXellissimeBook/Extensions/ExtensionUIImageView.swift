//
//  ExtensionUIImageView.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/08/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// MARK: - extension UIImageView
let imageCache = NSCache<AnyObject, AnyObject>()
let coverCache = NSCache<AnyObject, AnyObject>()

///This extension manages cache when loading profile images
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
                    return
                }
                if error != nil {
                    print("error here : \(error.debugDescription)")
                }
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
                    return
                }
                if error != nil {
                }
                if let downloadedImage = UIImage(data: data) {
                    coverCache.setObject(downloadedImage, forKey: isbnString as AnyObject)
                    self.image = downloadedImage
                }
                
                download.resume()
            })
        }
        
    }
    /**
     Function that manages uploading images via cache or download storage for book cover image
     */
    func loadingMessageImageUsingCacheWithisString(urlString : String){
        // first set nil to image to avoid brightness
        self.image = nil
        // Check cache for image : if image already in cache, use this image
        if let cachedImage = coverCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        // If image not in cache, launch download from Firebase and store image recently downloaded in cache to reuse it later
        var download:StorageDownloadTask!
        let storageRef = Storage.storage().reference().child(FirebaseUtilities.shared.messageImage).child("\(urlString).jpg")
        DispatchQueue.main.async {
            download = storageRef.getData(maxSize: 1024*1024*5, completion:  { (data, error) in
                guard let data = data else {
                    return
                }
                if error != nil {
                    print("error here : \(error.debugDescription)")
                }
                if let downloadedImage = UIImage(data: data) {
                    coverCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
                download.resume()
            })
        }
    }
}
