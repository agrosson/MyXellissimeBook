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


extension UIViewController {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}


let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadingImageUsingCacheWithUrlString(urlString : String){
        
        self.image = nil
        
        //Check cache for image first
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        
        // otherwise fire of new download
        
        var download:StorageDownloadTask!
        print("let's download")
        let storageRef = Storage.storage().reference().child("profileImage").child("\(urlString).jpg")
        DispatchQueue.main.async {
            print("let's be inside")
            download = storageRef.getData(maxSize: 1024*1024*5, completion:  { (data, error) in
                print("let's be inside download")
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
}
