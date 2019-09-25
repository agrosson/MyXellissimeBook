//
//  MapAnnotation.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/09/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation


// MARK: - MapAnnotation class
/**
 This class defines a map Annotation for mapKit
 
 It is used to display pin on map representing ths application users
 */

class MapAnnotation:NSObject {
    /// User latitude
    var latitude: Double?
    /// User longitude
    var longitude: Double?
    /// User name
    var userName: String?
    /// User profileId
    var userId: String?
    
    // MARK: - Initializer
       override init(){}
}
