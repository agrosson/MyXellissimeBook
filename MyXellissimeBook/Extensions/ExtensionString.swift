//
//  ExtensionString.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/08/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation


// MARK: - extension String
/**
 This extension enables to remove inaccurate whitespace
 */
extension String {
    mutating func removeFirstAndLastAndDoubleWhitespace() {
        var newString = self
        repeat {
            if newString.last == " " || newString.last == "\""{
                newString = String(newString.dropLast())
            }
            if newString.first == " " || newString.first == "\""{
                newString = String(newString.dropFirst())
            }
        }
            while newString.first == " " || newString.last == " " || newString.last == "\"" || newString.first == "\""
        repeat { newString = newString.replacingOccurrences(of: "  ", with: " ")
        } while newString.contains("  ")
        self =  newString
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String)-> String {
        guard self.hasSuffix(suffix) else {
            return self
        }
        return String(self.dropLast(suffix.count))
    }
    
}
