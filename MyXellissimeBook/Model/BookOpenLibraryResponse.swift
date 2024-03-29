//
//  BookOpenLibraryResponse.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 19/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation


// MARK: - Struct BookOpenLibraryResponse
/**
 This struct enables to get and manage information from BookOpenLibrary API Response
 */
struct BookOpenLibraryResponse: Codable {
    let publishers: [Publish]?
    let pagination: String?
    let identifiers: [String: [String]]?
    let subtitle, title: String?
    let url: String?
    let classifications: Classifications?
    let numberOfPages: Int?
    let cover: Cover?
    let subjectPlaces, subjects: [Author]?
    let publishDate, key: String?
    let authors: [Author]?
    let byStatement: String?
    let publishPlaces: [Publish]?
}

struct Author: Codable {
    let url: String?
    let name: String?
}

struct Classifications: Codable {
    let lcClassifications: [String]?
}

struct Cover: Codable {
    let small, large, medium: String?
}

struct Publish: Codable {
    let name: String?
}
