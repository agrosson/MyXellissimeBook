//
//  Book.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 19/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import Firebase

// MARK: - Book class
/**
 This class defines the book attributes
 */
class Book: NSObject {
    /// Unique Id of the book = give by ChildByAutoId from Firebase
    var uniqueId: String?
    /// Title of the book
    var title: String?
    /// Author(s) of the book
    var author: String?
    /// Publisher of the book
    var editor: String?
    /// Book Isbn 13 or other
    var isbn: String?
    /// Boolean that tracks if book is available for loan or not
    var isAvailable: Bool?
    /// Url as a string of downloaded cover image from API
    var coverURL: String?
    /// Timestamp de l'enregistrement du livre pour tri
    var timestamp: Int?
    
    // MARK: - Initializer
    override init(){}
}

