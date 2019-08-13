//
//  ExtensionUIColor.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/08/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

// MARK: - extension UIColor
/**
 Initializer for UIColor
 */
extension UIColor {
    convenience init(myRed: CGFloat, myGreen: CGFloat, myBlue: CGFloat){
        self.init(red: myRed/255, green: myGreen, blue: myBlue, alpha : 1)
    }
}
