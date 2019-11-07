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
    
    //These variables used in Firebase to avoid misspelling
    let users = "users"
    let profileImage = "profileImage"
    let messages = "messages"
    let user_messages = "user-messages"
    let user_books = "user-books"
    let books = "books"
    let coverImage = "coverImage"
    let loans = "loans"
    let user_loans = "user-loans"
    let messageImage = "messageImage"
    /// Variable used to retrieve a user name in Firebase
    var name = ""
    /// Variable used to retrieve a mapAnnotationin  Firebase
    var mapAnnotationArray = [MapAnnotation]()
    /**
     This function returns the user name
     
     - Returns: the user name as a String
     */
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
    /**
     This function returns a user name from a user id
     
     - Parameter userId: a userId
     - Parameter callBack: a closure with the name of the user
     
     */
    static func getUserNameFromUserId(userId: String, callBack: @escaping (String?) -> Void) {
        Database.database().reference().child(FirebaseUtilities.shared.users).child(userId).observeSingleEvent(of: .value) {  (snapshot) in
            self.shared.name = ""
            if let dictionary = snapshot.value as? [String : Any] {
                let name = (dictionary["name"] as? String)!
                callBack(name)
            }
        }
    }
    
    /**
     This function remove message from Firebase
     - Parameter messageId: The message id to delete
     - Parameter fromId: The message has been sent by fromId - delete node fromId/message
     - Parameter toId: The message has been sent to toId - delete node toId/message
     */
    static func deleteMessage(with messageId: String, fromId: String, toId: String){
        // delete message
        let ref = Database.database().reference().child(FirebaseUtilities.shared.messages).child(messageId)
        ref.removeValue { (error, dataref) in
            if error != nil {
                print("fail to delete message", error as Any)
                return
            }
        }
        // delete message for fromId
        let refFromId = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(fromId).child(toId).child(messageId)
        refFromId.removeValue { (error, dataref) in
            if error != nil {
                print("fail to delete message", error as Any)
                return
            }
        }
        // delete message for toId
        let refToId = Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(toId).child(fromId).child(messageId)
        refToId.removeValue { (error, dataref) in
            if error != nil {
                print("fail to delete message", error as Any)
                return
            }
        }
    }
    
    /**
     This function returns a user from a email
     
     - Parameter email: a userId
     - Parameter callBack: a closure with the user retrieved from the query
     */
    static func getUserFromEmail(email: String, callBack: @escaping (User) -> Void){
        let rootRef = Database.database().reference()
        // Create an object that returns all users with the email
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
                        let fcmToken = value["fcmToken"] as? String ?? "fcmToken not found"
                        let hasAcceptedConditions = value["hasAcceptedConditions"] as? String ?? "hasAcceptedConditions not found"
                        let timestampLastLogout = value["timestampLastLogout"] as? Int ?? 0
                        let timestampLastLogIn = value["timestampLastLogIn"] as? Int ?? 0
                        let timestamp = value["timestamp"] as? Int ?? 0
                        let latitude = value["latitude"] as? Double ?? 0
                        let longitude = value["longitude"] as? Double ?? 0
                        userTemp.name = name
                        userTemp.email = email
                        userTemp.profileId = profileId
                        userTemp.fcmToken = fcmToken
                        userTemp.hasAcceptedConditions = hasAcceptedConditions
                        userTemp.timestamp = timestamp
                        userTemp.timestampLastLogout = timestampLastLogout
                        userTemp.timestampLastLogIn = timestampLastLogIn
                        userTemp.latitude = latitude
                        userTemp.longitude = longitude
                        callBack(userTemp)
                    }
                }
            }
            if counterTrue == 0 {
                callBack(User())
            }
        }
    }
    
    /**
     This function returns a user from a profileId
     
     - Parameter profileId: a profileId
     - Parameter callBack: a closure with the user retrieved from the query
     */
    static func getUserFromProfileId(profileId: String, callBack: @escaping (User) -> Void){
        let rootRef = Database.database().reference()
        // Create an object that returns all users with the profileId
        let query = rootRef.child(FirebaseUtilities.shared.users).queryOrdered(byChild: "profileId")
        var counter = 0
        var counterTrue = 0
        query.observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                counter += 1
                if let value = child.value as? NSDictionary {
                    if profileId == value["profileId"] as? String {
                        counterTrue = +1
                        let userTemp = User()
                        let name = value["name"] as? String ?? "Name not found"
                        let email = value["email"] as? String ?? "Email not found"
                        let profileId = value["profileId"] as? String ?? "profileId not found"
                        let fcmToken = value["fcmToken"] as? String ?? "fcmToken not found"
                        let hasAcceptedConditions = value["hasAcceptedConditions"] as? String ?? "hasAcceptedConditions not found"
                        let timestamp = value["timestamp"] as? Int ?? 0
                        let timestampLastLogout = value["timestampLastLogout"] as? Int ?? 0
                        let timestampLastLogIn = value["timestampLastLogIn"] as? Int ?? 0
                        let latitude = value["latitude"] as? Double ?? 0
                        let longitude = value["longitude"] as? Double ?? 0
                        userTemp.name = name
                        userTemp.email = email
                        userTemp.profileId = profileId
                        userTemp.fcmToken = fcmToken
                        userTemp.hasAcceptedConditions = hasAcceptedConditions
                        userTemp.timestamp = timestamp
                        userTemp.timestampLastLogout = timestampLastLogout
                        userTemp.timestampLastLogIn = timestampLastLogIn
                        userTemp.latitude = latitude
                        userTemp.longitude = longitude
                        callBack(userTemp)
                    }
                }
            }
            if counterTrue == 0 {
                callBack(User())
            }
        }
    }
    
    /**
     This function saves a text as a message in Firebase
     
     - Parameter text: the text of the meassge to save
     - Parameter fromId: the sender Id as a String
     - Parameter toUser: the recipient user
     
     **/
    static func saveMessage(text: String, fromId : String, toUser: User) {
        let properties = ["messageImageUrl" : "messageImageUrl",
                          "imageHeight" : 0,
                          "imageWidth" : 0,
                          "text" : text,] as [String : Any]
        FirebaseUtilities.saveMessageOrImage(properties: properties, fromId: fromId, toUser: toUser)
        FirebaseUtilities.sendNotification(fromId: fromId, toUser: toUser)
    }
    
    
    /**
     This function saves an image reference as a message in Firebase
     
     - Parameter messageImageUrl: the image reference used to retrieve the image in Firebase Storage
     - Parameter fromId: the sender Id as a String
     - Parameter toUser: the recipient user
     - Parameter imageWidth: width of image
     - Parameter imageHeight: height of image
     
     */
    static func saveMessageImage(messageImageUrl: String, fromId : String, toUser: User, imageWidth: CGFloat, imageHeight: CGFloat) {
        
        let properties = ["messageImageUrl" : messageImageUrl,
                          "imageWidth" : imageWidth,
                          "imageHeight" : imageHeight,
                          "text" : ""] as [String : Any]
        FirebaseUtilities.saveMessageOrImage(properties: properties, fromId: fromId, toUser: toUser)
        FirebaseUtilities.sendNotification(fromId: fromId, toUser: toUser)
    }
    
    static func sendNotification(fromId : String, toUser: User) {
        print("here is the code to send Push Notification")
        
    }
    
    /**
     This function saves a text or Image as a message in Firebase
     
     - Parameter properties: Dictionary with all elements to save in Firebase
     - Parameter fromId: the sender Id as a String
     - Parameter toUser: the recipient user
     
     */
    static func saveMessageOrImage(properties : [String : Any], fromId : String, toUser: User) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.messages)
        /// unique reference for the message
        let childRef = ref.childByAutoId()
        /// get the recipient Id
        guard let toId = toUser.profileId else {return}
        let timestamp = Int(NSDate().timeIntervalSince1970)
        // Create a dictionary of values to save
        var values = ["toId" : toId,
                      "fromId" : fromId,
                      "timestamp" : timestamp] as [String : Any]
        // The dictionary is updated with the elements of properties, ie for each element of properties, update the value dictionary
        properties.forEach({values[$0] = $1})
        
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
    
    /**
     This function saves a book in Firebase
     
     - Parameter book: book to be stored
     - Parameter fromUserId: the book owner's Id as a String
     
     */
    static func saveBook(book: Book, fromUserId : String){
        let ref = Database.database().reference().child(FirebaseUtilities.shared.books)
        /// unique reference for the book
        guard let isbnForUniqueRefBok = book.isbn else {return}
        let uniqueRefForBook = "\(fromUserId)\(isbnForUniqueRefBok)"
        let childRef = ref.child(uniqueRefForBook)
        let timestamp = Int(NSDate().timeIntervalSince1970)
        //Create the dictionary of value to save
        let values = ["uniqueId" : childRef.key,
                      "title": book.title ?? "",
                      "author": book.author ?? "unknown",
                      "editor": book.editor ?? "unknown",
                      "isbn": book.isbn ?? "no isbn",
                      "isAvailable" : book.isAvailable ?? true,
                      "timestamp": timestamp,
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
    
    /**
     This function saves a cover image for a book with isbn in Firebase Storage
     
     - Parameter coverImage: UIImage of book cover to be stored
     - Parameter isbn: the isbn of the book. It will be used as the id of the cover image
     
     */
    static func saveCoverImage(coverImage: UIImage, isbn: String){
        // test the size in byte of the image
        let imageDataTest = coverImage.jpegData(compressionQuality: 1)
        guard let imageSize = imageDataTest?.count else {return}
        var imageDataToUpload = Data()
        if imageSize > 1500000 {
            guard let imageData = coverImage.jpegData(compressionQuality: 0.4) else {return}
            imageDataToUpload = imageData
        }
        if  1000000...1500000 ~= imageSize{
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
            print(progress.fractionCompleted)
        }
        uploadTask.resume()
    }
    
    /**
     This function saves an image as a message in Firebase Storage
     
     You can send either text or image to another User. Here is the case for image
     
     - Parameter imageAsMessage: UIImage to be stored
     - Parameter imageAsMessageName: the UIImage name
     */
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
        // Create the upload task to store image
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
     This function creates a loan  in Firebase with several properties
     - Parameter bookToLend: the book which is lent
     - Parameter fromId: the id of the lender as a String
     - Parameter toUser: the user of the borrower as a User
     - Parameter loanStartDate: the loan starting date as a String
     - Parameter expectedEndDateOfLoan: the loan expected end date as a String
     */
    static func saveLoan(bookToLend: Book, fromId : String, toUser: User, loanStartDate: Int,expectedEndDateOfLoan: Int) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.loans)
        /// unique reference for the message
        let childRef = ref.childByAutoId()
        /// get the recipient Id
        let loanId = childRef.key
        guard let bookId = bookToLend.uniqueId else {return}
        guard let toUserId = toUser.profileId else {return}
        guard let bookTitle = bookToLend.title else {return}
        // Create a dictionary of values to save as a loan 
        let values = ["uniqueLoanBookId" : loanId,
                      "bookId" : bookId,
                      "bookTitle" : bookTitle,
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
            FirebaseUtilities.updateBookAfterLoan(book: bookToLend, fromUserId: fromId)
        }
    }
    /**
     This function closes a loan  in Firebase
     - Parameter uniqueLoanBookId:  the loan id to be closed as a String
     */
    static func closeLoan(for uniqueLoanBookId: String){
        let ref = Database.database().reference().child(FirebaseUtilities.shared.loans).child(uniqueLoanBookId)
        let closeDate = Int(NSDate().timeIntervalSince1970)
        let values = ["effectiveEndDateOfLoan" : closeDate] as [String : Any]
        // this block to update the variable effectiveEndDateOfLoan with date of the day.
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
        }
    }
    /**
     This function saves  an email for a user  in Firebase
     - Parameter email:  the new email for the user
     - Parameter userUid:  the user uid
     */
    static func saveEmail(with email: String, for uid : String){
        let ref = Database.database().reference().child(FirebaseUtilities.shared.users).child(uid)
        let values = ["email" : email] as [String : Any]
        // this block to update the variable email
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
        }
    }
    
    /**
     This function saves  an name for a user  in Firebase
     - Parameter name:  the new name for the user
     - Parameter userUid:  the user uid
     */
    static func saveName(with name: String, for uid : String){
        let ref = Database.database().reference().child(FirebaseUtilities.shared.users).child(uid)
        let values = ["name" : name] as [String : Any]
        // this block to update the variable email
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
        }
    }
    
    /**
     This function removes token in Firebase for a user when logs out and set timestampLastLogout
     - Parameter uid:  the user uid
     */
    static func changeToken(uid: String) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.users).child(uid)
        let timestampLastLogout = Int(NSDate().timeIntervalSince1970)
        let value = ["fcmToken": "fcmToken",
                     "timestampLastLogout" : timestampLastLogout] as [String : Any]
        ref.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
        }
        
    }
    /**
     This function updates token in Firebase for a user when logs in and sets timestampLastLogIn
     - Parameter token:  the new token of user's device
     - Parameter uid:  the user uid
     */
    static func updateFcmTocken(with token: String, for userUid : String) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.users).child(userUid)
        let timestampLastLogIn = Int(NSDate().timeIntervalSince1970)
        let value = ["fcmToken": token,
                     "timestampLastLogIn" : timestampLastLogIn] as [String : Any]
        ref.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
        }
    }
    /**
     This function updates location in Firebase for a user
     - Parameter latitude:  the new latitude of user's device
     - Parameter longitude:  the new longitude of user's device
     - Parameter uid:  the user uid
     */
    static func updateUserLocation(latitude: Double, longitude : Double, userUid : String) {
        let ref = Database.database().reference().child(FirebaseUtilities.shared.users).child(userUid)
        let value = ["latitude": latitude,
                     "longitude" : longitude] as [String : Any]
        ref.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
        }
    }
    /**
     This function fetches location in Firebase for all user near current user
     - Parameter latitude:  the new latitude of user's device
     - Parameter longitude:  the new longitude of user's device
     - Parameter callBack: a closure with an array of MapAnnotation
     */
    static func fetchUserAnnotation(latitudeUser: Double, longitudeUser : Double, callBack: @escaping ([MapAnnotation]) -> Void) {
        self.shared.mapAnnotationArray = [MapAnnotation]()
        let rootRef = Database.database().reference().child(FirebaseUtilities.shared.users)
        
        rootRef.observe(.childAdded, with: { (snapshot) in
            DispatchQueue.main.async {
                // get the key for the userId
                let userId = snapshot.key
                rootRef.child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String : Any] else {return}
                    let mapAnnotation = MapAnnotation()
                    guard let latitude = dictionary["latitude"] as? Double else {return}
                    guard let longitude = dictionary["longitude"] as? Double else {return}
                    guard let name = dictionary["name"] as? String else {return}
                    guard let profileId = dictionary["profileId"] as? String else {return}
                    mapAnnotation.latitude = latitude
                    mapAnnotation.longitude = longitude
                    mapAnnotation.userName = name
                    mapAnnotation.userId = profileId
                    self.shared.mapAnnotationArray.append(mapAnnotation)
                })
            }
        })
        callBack(self.shared.mapAnnotationArray)
        
    }
    
    /**
     This function saves a book in Firebase
     
     - Parameter book: book to be stored
     - Parameter fromUserId: the book owner's Id as a String
     
     */
    static func updateBookAfterLoan(book: Book, fromUserId : String){
        let ref = Database.database().reference().child(FirebaseUtilities.shared.books)
        /// unique reference for the book
        guard let isbnForUniqueRefBok = book.isbn else {return}
        let uniqueRefForBook = "\(fromUserId)\(isbnForUniqueRefBok)"
        let childRef = ref.child(uniqueRefForBook)
        //Create the dictionary of value to save
        let values = ["isAvailable" : book.isAvailable ?? true] as [String : Any]
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
}
