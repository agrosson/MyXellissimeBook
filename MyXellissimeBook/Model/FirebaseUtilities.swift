//
//  FirebaseUtilities.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUtilities {
    
    static var shared = FirebaseUtilities()
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
    
    
    var name = ""
    
    static func getUserName() -> String? {
        guard let uid = Auth.auth().currentUser?.uid else {return "no name"}
        self.shared.name = "33"
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) {  (snapshot) in
            self.shared.name = ""
            if let dictionary = snapshot.value as? [String : Any] {
                self.shared.name = (dictionary["name"] as? String)!
                print("ici avec \(self.shared.name)")
            }
        }
      return self.shared.name
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
        let values = ["text" : text,
                      "toId" : toId,
                      "fromId" : fromId,
                      "timestamp" : timestamp] as [String : Any]
        // this block to save the message and then also make a reference and store the reference of message in antoher node
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            // create a new node fromId user
            let userMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(fromId)
            // get the key of the message
            let messageId = childRef.key
            // store the  message here for the fromId user
            userMessageRef.updateChildValues([messageId : 1])
            // create a new node toId user
            let recipientUserMessageRef = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(toId)
            // store the key message here for the toId user
            recipientUserMessageRef.updateChildValues([messageId : 1])
        }
    }
    
    /*******************************************************
     This function saves a book in firebase:
     
     Before saving, gather book atrributes and user Id
     ********************************************************/
    static func saveBook(book: Book, fromUserId : String){
        let ref = Database.database().reference().child(FirebaseUtilities.shared.books)
        /// unique reference for the book
        guard let isbnForUniqueRefBok = book.isbn else {return}
        let uniqueRefForBook = "\(fromUserId)\(isbnForUniqueRefBok)"
        let childRef = ref.child(uniqueRefForBook)
        //Create the dictionary of value to save
        let values = ["uniqueId" : childRef.key,
                      "title": book.title ?? "no title",
                      "author": book.author ?? "no author",
                      "editor": book.editor ?? "unknown",
                      "isbn": book.isbn ?? "no isbn",
                      "isAvailable" : book.isAvailable ?? false,
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
     This function saves a cover image in firebase Storage:
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
        if  100000...1000000 ~= imageSize {
            guard let imageData = coverImage.jpegData(compressionQuality: 0.7) else {return}
            imageDataToUpload = imageData
        }
        if  imageSize < 100000 {
            guard let imageData = coverImage.jpegData(compressionQuality: 0.7) else {return}
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
}
