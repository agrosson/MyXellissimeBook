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
import SafariServices



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
    /**
     Delegate function get info from picker, get photo and use it as profile photo
     */
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
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    

    /**
     Function that handles Registration
    
     When creating a user:
     1. Save user's data in database
     2. Store the image in Storage
     3. Dismiss the view controller
     */
    func handleRegister(){
        //get info from textFields
        guard var email = emailTextField.text, var password = passwordTextField.text, var name = nameTextField.text else {
            //Todo an alert to be done
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAllFieldsCompleted
            return
        }
        email.removeFirstAndLastAndDoubleWhitespace()
        password.removeFirstAndLastAndDoubleWhitespace()
        name.removeFirstAndLastAndDoubleWhitespace()
        
        if email.isEmpty || name.isEmpty || password.isEmpty {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAllFieldsCompleted
            return
        }
        if !isValidEmail(testStr: email) {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .emailBadlyFormatted
             return
        }
        if password.count < 6 {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .passwordIsTooShort
             return
        }
        // Ask User to accept conditions before sign in
        let actionSheet = UIAlertController(title: "Cher Utilisateur", message: "Vous devez accepter les conditions d'utilisation pour vous inscrire", preferredStyle: .alert)
        
        actionSheet.addAction(UIAlertAction(title: "Voir les conditions", style: .default, handler: { (action: UIAlertAction) in
            self.showConditionsInSafariVC()
            
        }))
        actionSheet.addAction(UIAlertAction(title: "J'ai lu et j'accepte les conditions", style: .default, handler: { (action: UIAlertAction) in
            //Create a user
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
                // identification creation failed
                if error != nil {
                    print(error.debugDescription)
                    Alert.shared.controller = self
                    Alert.shared.alertDisplay = .unableToCreateUser
                    return
                }
                // Create a unique UID for the user
                guard let uid = authDataResult?.user.uid else {
                    return
                }
                
                // Get the token for the user device
                guard let fcmToken = Messaging.messaging().fcmToken else {return}
                let timestamp = Int(NSDate().timeIntervalSince1970)
                let hasAcceptedConditions = "YES"
                
                // prepare dictionary with user info to upload in firebase
                let values = ["name" : name, "email" : email, "profileId" : uid, "fcmToken": fcmToken, "hasAcceptedConditions":hasAcceptedConditions, "timestamp": timestamp] as [String : Any]
                
                //Save user's data in database
                self.registerUserIntoDatabaseWithUid(uid: uid, values: values)
                
                // Store the image in Storage
                self.saveProfileImageForUser(uid: uid)
            }
            /*************************
             update the title of the initialVC with new name
             **************************/
            self.initialViewController?.fetchUserAndSetupNavBarTitle()
            /*************************
             Dismiss the view controller
             **************************/
            self.dismiss(animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Refuser", style: .cancel, handler: { (action: UIAlertAction) in
            print("conditions refusées")
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .conditionMustBeAccepted
        }))
        
        self.present(actionSheet, animated: true, completion : nil)

    }
    /**
     Function that handles upload of data user in Firebase
     - Parameter uid: the unique identifier (String) of the user
     - Parameter values: the user's data to be saved in Firebase db as a dictionary
     */
    private func registerUserIntoDatabaseWithUid(uid: String, values : [String: Any]) {
        let ref = Database.database().reference()
        let userReference = ref.child(FirebaseUtilities.shared.users).child(uid)
        userReference.updateChildValues(values, withCompletionBlock: { (errorUpdate, dataRefUpdate) in
            if errorUpdate != nil {
                print(errorUpdate?.localizedDescription as Any)
                return
            }
            /*************************
             update the title of the initialVC with new name
             **************************/
            self.initialViewController?.fetchUserAndSetupNavBarTitle()
        })
    }
    
    /**
     Function that update and upload of profile image of the user
     - Parameter uid: the unique identifier (String) of the user
     */
    func saveProfileImageForUser(uid : String){
        // get the profile image
        guard let image = self.profileImageView.image else {return}
        // update the cache
        imageCache.setObject(image, forKey: uid as AnyObject)
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
        let storageRef = Storage.storage().reference().child(FirebaseUtilities.shared.profileImage).child("\(uid).jpg")
        // Create a Storage Metadata
        let uploadMetadata = StorageMetadata()
        // Describe the type of image stored in FireStorage
        uploadMetadata.contentType = "image/jpeg"
        // Create the upload task
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
    /**
     Function that handles Login
     */
    func handleLoginWithProfileUpdate(update: Bool){
        // Get info from textField
        guard var email = emailTextField.text, var password = passwordTextField.text else {
            //Todo an alert to be done
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAllFieldsCompleted
            return
        }
        email.removeFirstAndLastAndDoubleWhitespace()
        password.removeFirstAndLastAndDoubleWhitespace()
        
        if email.isEmpty || password.isEmpty {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .needAllFieldsCompleted
            return
        }
        if !isValidEmail(testStr: email) {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .emailBadlyFormatted
            return
        }
        if password.count < 6 {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .passwordIsTooShort
            return
        }
        // Connect to Firebase Auth
        Auth.auth().signIn(withEmail: email, password: password) { (resultSignIn, errorSignIn) in
            if errorSignIn != nil {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .noUserFound
                return
            }
            /*************************
             update the title of the initialVC with new name
             **************************/
            if update == true {
                if let uid = Auth.auth().currentUser?.uid {
                    self.saveProfileImageForUser(uid:uid )
                }
            }
            self.initialViewController?.fetchUserAndSetupNavBarTitle()
            self.dismiss(animated: true, completion: nil)
            print("\(email) has been  successfully logged in !")
            if let uid = Auth.auth().currentUser?.uid {
                if let fcm = Messaging.messaging().fcmToken {
                    FirebaseUtilities.updateFcmTocken(with: fcm, for: uid)
                    self.checkIfMessagesDuringLogout(for: uid)
                }
            }
        }
    }
    
    /**
     Function that shows condition on web site with safari
     */
    private func showConditionsInSafariVC(){
        guard let url = URL(string: "https://xellissime.blogspot.com/") else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    private func checkIfMessagesDuringLogout(for uid: String){
        observeUserMessages()
    }
    
    /**
     function that observes all messages send by or received by a single user
     */
    private func observeUserMessages(){
        // get the Id of the user
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        // get the ref of list of message for this uid
        let ref = Database.database().reference().child("user-messages").child(uid)
        // observe the node
        ref.observe(.childAdded, with: { (snapshot) in
            // get the key for the userId
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                // get the key for the message
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId, usedId: uid )
                
            }, withCancel: nil)
            //    return
        }, withCancel: nil)
           DatabaseReference().removeAllObservers()
        if newMessage {
            Alert.shared.controller = self
            Alert.shared.alertDisplay = .newMessagesAfterLogin
        }
    }
    
    /**
     function that fetches message
     - Parameter messageId: the unique identifier (String) of the message in Firebase
     */
    private func fetchMessageWithMessageId(messageId: String, usedId: String) {
        //get the reference of the message
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        // observe the messages for this user
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            let message = Message(dictionary: dictionary)
            if let timeToCheck = message.timestamp {
                FirebaseUtilities.getUserFromProfileId(profileId: usedId, callBack: { user in
                    guard let timeLogin = user.timestampLastLogIn else {return}
                    if let timeLogout = user.timestampLastLogout {
                        if timeToCheck > timeLogout && timeToCheck < timeLogin {
                            newMessage = true
                        }
                    }
                    DatabaseReference().removeAllObservers()
                })
            }
        }, withCancel: nil)
    }
    
}

