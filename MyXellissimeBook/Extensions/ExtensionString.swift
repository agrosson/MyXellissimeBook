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
/**
 This extension returns a date fron a string format "dd.MM.yyyy"
 */

extension String {
    func toDateLoan(withFormat format: String = "dd.MM.yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
}

/**
 This extension calculates Jaro-Wringler distance between two Strings thanks to a static function
 Implementation:
 String.jaroWinglerDistance("First String", "Second String")
 */
extension String {
    /**
     Function that returns distance from 2 strings with Jaro-Wringler algorithm
     - Parameter first: First string to compare
     - Parameter second: Second string to compare
     - Returns: Distance from two strings as a Float
     */
    static func jaroWinglerDistance(_ first: String, _ second: String) -> Float {
        let firstUpper = first.uppercased()
        let secondUpper = second.uppercased()
        let longer = Array(firstUpper.count > secondUpper.count ? firstUpper : secondUpper)
        let shorter = Array(firstUpper.count > secondUpper.count ? secondUpper : firstUpper)
        let (numMatches, numTranspositions) = jaroWinklerData(longer: longer, shorter: shorter)
        if numMatches == 0 {return 0}
        let defaultScalingFactor = 0.2;
        let percentageRoundValue = 100.0;
        let jaro = [
            numMatches / Float(firstUpper.count),
            numMatches / Float(secondUpper.count),
            (numMatches - numTranspositions) / numMatches
            ].reduce(0, +) / 3
        let jaroWinkler: Float
        if jaro < 0.7 {
            jaroWinkler = jaro
        } else {
            let commonPrefixLength = Float(commonPrefix(firstUpper, secondUpper).count)
            jaroWinkler = jaro + Swift.min(Float(defaultScalingFactor), 1 / Float(longer.count)) * commonPrefixLength * (1 - jaro)
        }
        return round(jaroWinkler * Float(percentageRoundValue)) / Float(percentageRoundValue)
    }
    private static func commonPrefix(_ first: String, _ second: String) -> String{
        return String(
            zip(first, second)
                .prefix { $0.0 == $0.1 }
                .map { $0.0 })
    }
    private static func jaroWinklerData(
        longer: Array<Character>,
        shorter: Array<Character>
        ) -> (numMatches: Float, numTranspositions: Float) {
        let window = Swift.max(longer.count / 2 - 1, 0)
        var shorterMatchedChars: [Character] = []
        var longerMatches = Array<Bool>(repeating: false, count: longer.count)
        for (offset, shorterChar) in shorter.enumerated() {
            let windowRange = Swift.max(offset - window, 0) ..< Swift.min(offset + window + 1, longer.count)
            if let matchOffset = windowRange.first(where: { !longerMatches[$0] && shorterChar == longer[$0] }) {
                shorterMatchedChars.append(shorterChar)
                longerMatches[matchOffset] = true
            }
        }
        let longerMatchedChars = longerMatches
            .enumerated()
            .filter { $0.element }
            .map { longer[$0.offset] }
        let numTranspositions: Int = zip(shorterMatchedChars, longerMatchedChars)
            .lazy
            .filter { $0.0 != $0.1 }
            .count / 2
        return (
            numMatches: Float(shorterMatchedChars.count),
            numTranspositions: Float(numTranspositions)
        )
    }
}
