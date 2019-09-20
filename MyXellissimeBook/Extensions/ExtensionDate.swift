//
//  ExtensionDate.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 20/09/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation


/**
 This extension return a string with format "dd.MM.yyyy" from date
 */
extension Date {
    func formatDateTo_dd_dot_MM_dot_yyyy() -> String {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd.MM.yyyy"
        let stringOfDate = dateFormate.string(from: self)
        return stringOfDate
    }
}
