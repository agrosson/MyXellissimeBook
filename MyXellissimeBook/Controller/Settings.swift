//
//  Settings.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 07/10/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMobileAds
import SafariServices

// MARK: - Class InitialViewController
/**
 This class defines the InitialViewController
 */
class SettingsViewController: UIViewController {
    let containerView = CustomUI().view
    let modifyUserProfileImageButton = CustomUI().button
    let modifyUserPasswordButton = CustomUI().button
    let modifyUserNameButton = CustomUI().button
    let modifyUserEmailButton = CustomUI().button
    let modifyUserAreaButton = CustomUI().button
    let tutorialButton = CustomUI().button
    /// User Profile Image
    var userProfileImage = UIImage()
    var email: String?
    
    /// Var to track if user is authorized to see the tutorial : 0 is no
    var userCanWatchTutorial = 0
    override func viewDidLoad() {
        email = Auth.auth().currentUser?.email
        setupNavigationBar()
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    typealias Completion = (Error?) -> Void
    
    /**
     Action that dismisses VC when "Retour" button clicked
     */
    @objc func handleCancel(){
        self.dismiss(animated: true, completion: nil)
    }
    /**
     Action that modifies user profile photo
     */
    @objc func handleModifyProfilePhoto(){
        // Display picker to get the new photo/Image
        launchPicker()
    }
    /**
     Action that modifies user profile photo
     */
    @objc func handleTutorial(){
        guard let url = URL(string: urlForTutorials) else {
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    /**
     Action that modifies user password
     */
    @objc func handleModifyPassword(){
        alertToModifyPassword(title: "Modification du mot de passe", message: "Indiquer l'ancien mot de passe et\nle nouveau mot de passe")
    }
    /**
     Action that modifies user name
     */
    @objc func handleModifyUserName(){
        alertToModifyName(title: "Modification du nom d'utilisateur", message: "Indiquer le mot de passe et\nindiquer votre nouveau nom utilisateur")
    }
    /**
    Action that modifies user name
    */
    @objc func handleModifyArea() {
         alertToModifyArea(title: "Modification de la ville", message: "Indiquer votre ville")
    }
    /**
     Action that modifies user name
     */
    @objc func handleModifyEmail(){
        alertToModifyEmail(title: "Modification de l'email", message: "Indiquer le mot de passe et\nindiquer votre nouvel email")
    }
    func launchPicker() {
        // create a instance of UIImagePickerController()
        let picker = UIImagePickerController()
        // delegate to self
        picker.delegate = self
        // Enable to edit the photo (zoom, resize etc)
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        // present the picker
        present(picker, animated: true, completion: nil)
    }
    
    /**
     Function that update and upload of profile image of the user
     - Parameter uid: the unique identifier (String) of the user
     - Parameter image: the new image for user profile image
     */
    func saveProfileImageForUser(uid : String, image: UIImage){
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
    @objc func alertIdenticalPassword() {
        Alert.shared.controller = self
        Alert.shared.alertDisplay = .invalidPasswordChangeIdentical
    }
    /**
     Function that creates an alert with 2 textfields to modify password
     - Parameter title: The alert title
     - Parameter message: The alert message
     */
    func alertToModifyEmail(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction (UIAlertAction(title: "Sauvegarder", style: .default) { (alertAction) in
            guard let password = alert.textFields![0].text else {
                return
            }
            guard let newEmail = alert.textFields![1].text else {
                return
            }
            if !self.isValidEmail(testStr: newEmail) {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .emailBadlyFormatted
                return
            }
            if let email = self.email {
                self.changeEmail(email: email, currentPassword: password, newEmail: newEmail) { (error) in
                    if error == nil {
                        guard let uid = Auth.auth().currentUser?.uid else {return}
                        FirebaseUtilities.saveEmail(with: newEmail, for: uid)
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .emailChanged
                    } else {
                        print(error as Any)
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .emailNotChanged
                    }
                }
            }
        })
        alert.addTextField { (textField) in
            textField.placeholder = "Mot de passe"
            textField.textColor = mainBackgroundColor
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Nouvel email"
            textField.textColor = mainBackgroundColor
        }
        alert.addAction(UIAlertAction(title: "Annuler", style: .default) { (alertAction) in })
        self.present(alert, animated:true, completion: nil)
    }
    /**
     Function that creates an alert with 2 textfields to modify password
     - Parameter title: The alert title
     - Parameter message: The alert message
     */
    func alertToModifyPassword(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction (UIAlertAction(title: "Sauvegarder", style: .default) { (alertAction) in
            guard let oldPassword = alert.textFields![0].text else {
                return
            }
            guard let newPassword = alert.textFields![1].text else {
                return
            }
            if newPassword == oldPassword {
                self.alertIdenticalPassword()
                return
            }
            // test if password has at least 6 characters
            if newPassword.count < 5 {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .passwordIsTooShort
                return
            }
            if let email = self.email {
                self.changePassword(email: email, currentPassword: oldPassword, newPassword: newPassword) { (error) in
                    if error != nil {
                        print(error as Any)
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .passwordNotChanged
                    } else {
                        Alert.shared.controller = self
                        Alert.shared.alertDisplay = .passwordChanged
                    }
                }
            }
        })
        //Step : 3
        //For first TF
        alert.addTextField { (textField) in
            textField.placeholder = "Ancien mot de passe"
            textField.textColor = mainBackgroundColor
        }
        //For second TF
        alert.addTextField { (textField) in
            textField.placeholder = "Nouveau mot de passe"
            textField.textColor = mainBackgroundColor
        }
        //alertC.setBackgroundColor(color: mainBackgroundColor)
        //Cancel action
        alert.addAction(UIAlertAction(title: "Annuler", style: .default) { (alertAction) in })
        self.present(alert, animated:true, completion: nil)
    }
    /**
     Function that creates an alert with 2 textfields to modify name
     - Parameter title: The alert title
     - Parameter message: The alert message
     */
    func alertToModifyName(title: String, message: String) {
        //Step : 1
        let alertC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //Step : 2
        alertC.addAction (UIAlertAction(title: "Sauvegarder", style: .default) { (alertAction) in
            guard let password = alertC.textFields![0].text else {
                return
            }
            guard let newname = alertC.textFields![1].text else {
                return
            }
            if newname.isEmpty {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .noData
            }
            if let email = self.email {
                self.changeName(email: email, currentPassword: password, newName: newname)
            }
        })
        
        //Step : 3
        //For first TF
        alertC.addTextField { (textField) in
            textField.placeholder = "Mot de passe"
            textField.textColor = mainBackgroundColor
        }
        //For second TF
        alertC.addTextField { (textField) in
            textField.placeholder = "Nouveau nom d'utilisateur"
            textField.textColor = mainBackgroundColor
        }
        //alertC.setBackgroundColor(color: mainBackgroundColor)
        //Cancel action
        alertC.addAction(UIAlertAction(title: "Annuler", style: .default) { (alertAction) in })
        self.present(alertC, animated:true, completion: nil)
    }
    /**
     Function that creates an alert with 2 textfields to modify area
     - Parameter title: The alert title
     - Parameter message: The alert message
     */
    func alertToModifyArea(title: String, message: String) {
        //Step : 1
        let alertC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //Step : 2
        alertC.addAction (UIAlertAction(title: "Sauvegarder", style: .default) { (alertAction) in
            guard let password = alertC.textFields![0].text else {
                return
            }
            guard let newArea = alertC.textFields![1].text else {
                return
            }
            if newArea.isEmpty {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .noData
            }
            if let email = self.email {
                self.changeArea(email: email, currentPassword: password, newArea: newArea)
            }
        })
        
        //Step : 3
        //For first TF
        alertC.addTextField { (textField) in
            textField.placeholder = "Mot de passe"
            textField.textColor = mainBackgroundColor
        }
        //For second TF
        alertC.addTextField { (textField) in
            textField.placeholder = "Votre ville"
            textField.textColor = mainBackgroundColor
        }
        //alertC.setBackgroundColor(color: mainBackgroundColor)
        //Cancel action
        alertC.addAction(UIAlertAction(title: "Annuler", style: .default) { (alertAction) in })
        self.present(alertC, animated:true, completion: nil)
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func changePassword(email: String, currentPassword: String, newPassword: String, completion: @escaping Completion) {
        if let currentUser = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (authResult, error) in
                if error == nil {
                    currentUser.updatePassword(to: newPassword) { (error) in
                        completion(error)
                    }
                }
                else {
                    Alert.shared.controller = self
                    Alert.shared.alertDisplay = .passwordNotChanged
                }
            })
        }
    }
    func changeEmail(email: String, currentPassword: String, newEmail: String, completion: @escaping Completion) {
        if let currentUser = Auth.auth().currentUser {
            let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (authResult, error) in
                if error == nil {
                    currentUser.updateEmail(to: newEmail) { (error) in
                        completion(error)
                    }
                } else {
                    Alert.shared.controller = self
                    Alert.shared.alertDisplay = .emailNotChanged
                }
            })
        }   
    }
    func changeName(email: String, currentPassword: String, newName: String) {
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (authResult, error) in
            if error == nil {
                FirebaseUtilities.saveName(with: newName, for: uid)
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .nameChanged
            } else {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .nameNotChanged
            }
        })
    }
    func changeArea(email: String, currentPassword: String, newArea: String) {
        guard  let uid = Auth.auth().currentUser?.uid else {return}
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        Auth.auth().currentUser?.reauthenticateAndRetrieveData(with: credential, completion: { (authResult, error) in
            if error == nil {
                FirebaseUtilities.saveArea(with: newArea, for: uid)
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .areaChanged
            } else {
                Alert.shared.controller = self
                Alert.shared.alertDisplay = .areaNotChanged
            }
        })
    }
}
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker = UIImage()
        // Get edited or originl image from picker
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else {
            guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
            selectedImageFromPicker = originalImage
        }
        self.userProfileImage = selectedImageFromPicker
        self.dismiss(animated: true, completion: {
            // Get user's uid
            guard let uid = Auth.auth().currentUser?.uid else {return}
            self.saveProfileImageForUser(uid: uid, image: self.userProfileImage)})
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIAlertController {
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
}
