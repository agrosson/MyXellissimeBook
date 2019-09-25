//
//  ExtensionsView.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 24/09/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: UIView...){
        views.forEach{addSubview($0)}
    }
}
