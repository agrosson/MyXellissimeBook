//
//  LoginControler+handlers.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 14/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     Function that handles selection of photo profile
     */
    @objc func handleSelectProfileImage() {
        // create a instance of UIImagePickerController()
        let picker = UIImagePickerController()
        
        // delegate to self
        picker.delegate = self
        // Enable to edit the photo (zoom, resize etc)
        picker.allowsEditing = true
        // present the picker
        present(picker, animated: true, completion: nil)
    }
    //delegate function get info from picker
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker = UIImage()
        // Get edited or originl image from picker
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else {
            guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
            selectedImageFromPicker = originalImage
        }
        self.profileImageView.image = selectedImageFromPicker
        self.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
