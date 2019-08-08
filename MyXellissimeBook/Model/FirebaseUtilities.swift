//
//  FirebaseUtilities.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import Firebase


// MARK: - class FirebaseUtilities
/**
 This struct enables to manage relationships with Firebase (database and storage)
 */
class FirebaseUtilities {
    
    static var shared = FirebaseUtilities()
    // MARK: - Initializer
    private init(){}
    
    /*******************************************************
     These variables used in Firebase to avoid misspelling
     ********************************************************/
    
    let users = "users"
    let profileImage = "profileImage"
    let messages = "messages"
    let user_messages = "user-messages"
    let user_books = "user-books"
    let books = "books"
    let coverImage = "coverImage"
    let loan = "loan"
    let user_loans = "user-loans"
    let messageImage = "messageImage"
    
    
    var name = ""
    /*******************************************************
     This function returns the user name
     ********************************************************/
    static func getUserName() -> String? {
        guard let uid = Auth.auth().currentUser?.uid else {return "no name"}
        self.shared.name = ""
        Database.database().reference().child(FirebaseUtilities.shared.users).child(uid).observeSingleEvent(of: .value) {  (snapshot) in
            self.shared.name = ""
            if let dictionary = snapshot.value as? [String : Any] {
                self.shared.name = (dictionary["name"] as? String)!
            }
        }
        return self.shared.name
    }
    /*******************************************************
     This function returns a user name from a user id
     ********************************************************/
    static func getUserNameFromUserId(userId: String, callBack: @escaping (String?) -> Void) {
        Database.database().reference().child(FirebaseUtilities.shared.users).child(userId).observeSingleEvent(of: .value) {  (snapshot) in
            self.shared.name = ""
            if let dictionary = snapshot.value as? [String : Any] {
                let name = (dictionary["name"] as? String)!
                callBack(name)
            }
        }
    }
    
    
    /*******************************************************
     This function returns a user from a email
     ********************************************************/
    static func getUserFromEmail(email: String, callBack: @escaping (User) -> Void){
        let rootRef = Database.database().reference()
        let query = rootRef.child(FirebaseUtilities.shared.users).queryOrdered(byChild: "email")
        var counter = 0
        var counterTrue = 0
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                counter += 1
                if let value = child.value as? NSDictionary {
                    if email == value["email"] as? String {
                        counterTrue = +1
                        let userTemp = User()
                        let name = value["name"] as? String ?? "Name not found"
                        let email = value["email"] as? String ?? "Email not found"
                        let profileId = value["profileId"] as? String ?? "profileId not found"
                        userTemp.name = name
                        userTemp.email = email
                        userTemp.profileId = profileId
                        callBack(userTemp)
                    }
                }
            }
            if counterTrue == 0 {
                callBack(User())
            }
        }
    }
    
    /*******************************************************
     This function saves a text as a message in firebase
     ********************************************************/
    static func saveMessage(text: String, fromId : String, toUser: User) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.messages)
        /// unique reference for the message
        let childRef = ref.childByAutoId()
        /// get the recipient Id
        guard let toId = toUser.profileId else {return}
        let timestamp = Int(NSDate().timeIntervalSince1970)
        // Create a dictionary of values to save
        let values = ["messageImageUrl" : "messageImageUrl",
                      "text" : text,
                      "toId" : toId,
                      "fromId" : fromId,
                      "timestamp" : timestamp] as [String : Any]
        // this block to save the message and then also make a reference and store the reference of message in antoher node
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            // create a new node fromId user and toId user
            let userMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(fromId).child(toId)
            // get the key of the message
            let messageId = childRef.key
            // store the  message here for the fromId user
            userMessageRef.updateChildValues([messageId : 1])
            // create a new node toId user and fromId user
            let recipientUserMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(toId).child(fromId)
            // store the key message here for the toId user
            recipientUserMessageRef.updateChildValues([messageId : 1])
        }
    }
    
    /*******************************************************
     This function saves a text as a message in firebase
     ********************************************************/
    static func saveMessageImage(messageImageUrl: String, fromId : String, toUser: User) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.messages)
        /// unique reference for the message
        let childRef = ref.childByAutoId()
        /// get the recipient Id
        guard let toId = toUser.profileId else {return}
        let timestamp = Int(NSDate().timeIntervalSince1970)
        // Create a dictionary of values to save
        let values = ["messageImageUrl" : messageImageUrl,
                      "text" : "",
                      "toId" : toId,
                      "fromId" : fromId,
                      "timestamp" : timestamp] as [String : Any]
        // this block to save the message and then also make a reference and store the reference of message in antoher node
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            // create a new node fromId user and toId user
            let userMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(fromId).child(toId)
            // get the key of the message
            let messageId = childRef.key
            // store the  message here for the fromId user
            userMessageRef.updateChildValues([messageId : 1])
            // create a new node toId user and fromId user
            let recipientUserMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(toId).child(fromId)
            // store the key message here for the toId user
            recipientUserMessageRef.updateChildValues([messageId : 1])
        }
    }
    
    /*******************************************************
     This function saves a book in firebase:
     Before saving, gather book atributes and user Id
     ********************************************************/
    static func saveBook(book: Book, fromUserId : String){
        let ref = Database.database().reference().child(FirebaseUtilities.shared.books)
        /// unique reference for the book
        guard let isbnForUniqueRefBok = book.isbn else {return}
        let uniqueRefForBook = "\(fromUserId)\(isbnForUniqueRefBok)"
        let childRef = ref.child(uniqueRefForBook)
        //Create the dictionary of value to save
        let values = ["uniqueId" : childRef.key,
                      "title": book.title ?? "",
                      "author": book.author ?? "unknown",
                      "editor": book.editor ?? "unknown",
                      "isbn": book.isbn ?? "no isbn",
                      "isAvailable" : book.isAvailable ?? true,
                      "coverURL" : book.coverURL ?? "no url"] as [String : Any]
        // this block to save the message and then also make a reference and store the reference of message in antoher node
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            // create a new node fromId user
            let userBookRef = Database.database().reference().child(FirebaseUtilities.shared.user_books).child(fromUserId)
            // get the key of the message
            let bookId = childRef.key
            // store the  message here for the fromId user
            userBookRef.updateChildValues([bookId : 1])
        }
    }
    
    /*******************************************************
     This function saves a cover image for a book with isbn in firebase Storage:
     ********************************************************/
    static func saveCoverImage(coverImage: UIImage, isbn: String){
        // test the size in byte of the image
        let imageDataTest = coverImage.jpegData(compressionQuality: 1)
        guard let imageSize = imageDataTest?.count else {return}
        var imageDataToUpload = Data()
        if imageSize > 1000000 {
            guard let imageData = coverImage.jpegData(compressionQuality: 0.5) else {return}
            imageDataToUpload = imageData
        }
        if  500000...1000000 ~= imageSize {
            guard let imageData = coverImage.jpegData(compressionQuality: 0.70) else {return}
            imageDataToUpload = imageData
        }
        if  100000...500001 ~= imageSize {
            guard let imageData = coverImage.jpegData(compressionQuality: 0.8) else {return}
            imageDataToUpload = imageData
        }
        if  imageSize < 100000 {
            guard let imageData = coverImage.jpegData(compressionQuality: 1) else {return}
            imageDataToUpload = imageData
        }
        // Create a Storage reference with the coverImage
        let storageRef = Storage.storage().reference().child(FirebaseUtilities.shared.coverImage).child("\(isbn).jpg")
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
    
    /*******************************************************
     This function saves an image as a message in firebase Storage:
     ********************************************************/
    static func saveImageAsMessage(imageAsMessage: UIImage, imageAsMessageName : String){
        // test the size in byte of the image
        let imageDataTest = imageAsMessage.jpegData(compressionQuality: 1)
        guard let imageSize = imageDataTest?.count else {return}
        var imageDataToUpload = Data()
        if imageSize > 1000000 {
            guard let imageData = imageAsMessage.jpegData(compressionQuality: 0.5) else {return}
            imageDataToUpload = imageData
        }
        if  500000...1000000 ~= imageSize {
            guard let imageData = imageAsMessage.jpegData(compressionQuality: 0.70) else {return}
            imageDataToUpload = imageData
        }
        if  100000...500001 ~= imageSize {
            guard let imageData = imageAsMessage.jpegData(compressionQuality: 0.8) else {return}
            imageDataToUpload = imageData
        }
        if  imageSize < 100000 {
            guard let imageData = imageAsMessage.jpegData(compressionQuality: 1) else {return}
            imageDataToUpload = imageData
        }
        
        // Create a Storage reference with the imageAsMessage
        let storageRef = Storage.storage().reference().child(FirebaseUtilities.shared.messageImage).child("\(imageAsMessageName).jpg")
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
    
    
    /*******************************************************
     This function creates a loan  in firebase
     ********************************************************/
    static func saveLoan(bookToLend: Book, fromId : String, toUser: User, loanStartDate: String,expectedEndDateOfLoan: String) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.loan)
        /// unique reference for the message
        let childRef = ref.childByAutoId()
        /// get the recipient Id
        let loanId = childRef.key
        guard let bookId = bookToLend.uniqueId else {return}
        guard let toUserId = toUser.profileId else {return}
        // Create a dictionary of values to save as a loan 
        let values = ["uniqueLoanBookId" : loanId,
                      "bookId" : bookId,
                      "fromUser" : fromId,
                      "toUser" : toUserId,
                      "loanStartDate" : loanStartDate,
                      "expectedEndDateOfLoan" : expectedEndDateOfLoan] as [String : Any]
        // this block to save the loan and then also make a reference and store the reference of message in antoher node
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            // create a new node fromId user
            let lenderRef = Database.database().reference().child(FirebaseUtilities.shared.user_loans).child(fromId)
            // store the  message here for the fromId user
            lenderRef.updateChildValues([loanId : 1])
            // create a new node toId user
            let borrowerRef = Database.database().reference().child(FirebaseUtilities.shared.user_loans).child(toUserId)
            // store the key message here for the toId user
            borrowerRef.updateChildValues([loanId : 1])
            // update availability of the book
            bookToLend.isAvailable = false
            FirebaseUtilities.saveBook(book: bookToLend, fromUserId: fromId)
        }
    }
    /*******************************************************
     This function closes a loan  in firebase
     ********************************************************/
    static func closeLoan(for uniqueLoanBookId: String){
        let ref = Database.database().reference().child(FirebaseUtilities.shared.loan).child(uniqueLoanBookId)
        //Create the dictionary of value to save
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd.MM.yyyy"
        let closeDate = dateFormate.string(from: Date())
        let values = ["effectiveEndDateOfLoan" : closeDate] as [String : Any]
        // this block to save the message and then also make a reference and store the reference of message in antoher node
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
        }
    }
}
