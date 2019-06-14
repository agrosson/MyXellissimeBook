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
    /**
     Function that handles Registration
     */
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            //Todo an alert to be done
            print("Should create an alert")
            return
        }
        
        // Create a user
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            // identification creation failed
            if error != nil {
                print(error.debugDescription)
                print("identification creation failed")
                return
            }
            // Create a unique UID for the user
            guard let uid = authDataResult?.user.uid else {
                return
            }
            let values = ["name" : name, "email" : email, "profileImageURL" : uid]
            print("do we are at list ? ")
            self.registerUserIntoDatabaseWithUid(uid: uid, values: values)
            // First store the imageProfile of user
            
            guard let image = self.profileImageView.image else {return}
            
            // test the size in byte of the image
            let imageDataTest = image.jpegData(compressionQuality: 1)
            guard let imageSize = imageDataTest?.count else {return}
            var imageDataToUpload = Data()
            if imageSize > 1000000 {
                 guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
                imageDataToUpload = imageData
            }
            if  100000...1000000 ~= imageSize {
                guard let imageData = image.jpegData(compressionQuality: 0.7) else {return}
                imageDataToUpload = imageData
            }
            if  imageSize < 100000 {
                guard let imageData = image.jpegData(compressionQuality: 0.7) else {return}
                imageDataToUpload = imageData
            }
            // Create a Storage reference with the bookId
            let storageRef = Storage.storage().reference().child("profileImage").child("\(uid).jpg")
            // Create a Storage Metadata
            let uploadMetadata = StorageMetadata()
            // Describe the type of image stored in FireStorage
            uploadMetadata.contentType = "image/jpeg"
            // Create the uopload task
            let uploadTask = storageRef.putData(imageDataToUpload, metadata: uploadMetadata) { (metada, error) in
                if error != nil {
                    print("i received an error \(error?.localizedDescription ?? "error but no description")")
                }   else {
                    print("up load complete, here some metadata \(String(describing: metada))")
                }
            }
            uploadTask.observe(.progress) { (snapshot) in
                guard let progress = snapshot.progress else {
                    print("No progress for the snapshot")
                    return}
                print("end of progress?? ")
                print(progress.fractionCompleted)
            }
            uploadTask.resume()
        }
          self.dismiss(animated: true, completion: nil)
    }
    private func registerUserIntoDatabaseWithUid(uid: String, values : [String: Any]) {
        print("do we are here? ")
        print(values)
        let ref = Database.database().reference(fromURL: "https://myxellissimebook.firebaseio.com")
        let userReference = ref.child("users").child(uid)
        print("do we are here? and here")
        userReference.updateChildValues(values, withCompletionBlock: { (errorUpdate, dataRefUpdate) in
            print("do we are here? an again ")
            if errorUpdate != nil {
                print(errorUpdate?.localizedDescription as Any)
                return
            }
            print("\(String(describing: values["name"])) has been saved successfully in FireBase database")
        })
    }
}

