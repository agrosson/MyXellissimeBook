//
//  MyTextRecognizer.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/08/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices


// MARK: - Message class
/**
 This class defines the text recognizer attributes and functionalities
 */

class MyTextRecognizer {
    
    static var shared = MyTextRecognizer()
    // MARK: - Initializer
    private init(){}
    
    /// Declaration of VisionTextRecognizer
    var textRecognizer: VisionTextRecognizer!
    
    // MARK: Text recognition
    static func textRecognizerFunction(image: UIImage){
        let vision = Vision.vision()
        MyTextRecognizer.shared.textRecognizer = vision.onDeviceTextRecognizer()
        MyTextRecognizer.runTextRecognition(with: image)
    }
    
    static func runTextRecognition(with image: UIImage) {
        let imageVision = VisionImage(image: image)
        MyTextRecognizer.shared.textRecognizer.process(imageVision) { (features, error) in
            self.processResult(from: features, error: error)
        }
        
    }
    
    // MARK: Text drawing
    static func processResult(from text : VisionText?, error: Error?) {
        guard let features = text else {
            print("no text found on picture")
            return
        }
        var globalArray = [String]()
        for block in features.blocks {
            let blockText = block.text
            print("Paragraph \(blockText)")
       //     let testArray = MyTextRecognizer.breakDown(of: blockText)
            globalArray.append(blockText)
            for line in block.lines {
                _ = line.text
                for element in line.elements {
                    _ = element.text
                }
            }
        }
        print("GlobalArrray = \(globalArray)")
        MyTextRecognizer.setTitleAuthorAndEditor(with: globalArray)
    }
    /**
     Function that decompose a string (text) into a array of string (sentences)
     - Parameter text: text to decompose
     - Returns: Array of String (sentences)
     */
    static func breakDown(of text : String) -> [String] {
        // Step 1: create an array of words
        var arrayOfWords = [String]()
        var stringToAddInTableau = ""
        var counter = 0
        for item in text {
            if item.isUppercase {
                stringToAddInTableau.append(item)
            } else {
                if !item.isWhitespace {
                    stringToAddInTableau.append(item)
                }
                else {
                    arrayOfWords.append(stringToAddInTableau)
                    stringToAddInTableau = ""
                }
            }
            counter += 1
            if  counter == text.count {
                arrayOfWords.append(stringToAddInTableau)
            }
        }
        // Step 2: create an array of sentences
        var arrayOfSentence = [String]()
        var stringToAddInFinalArray = ""
        var counterArray = 0
        for word in arrayOfWords {
            counterArray += 1
            if counterArray == 1 {
                stringToAddInFinalArray = word
            } else {
                if !word.first!.isUppercase {
                    stringToAddInFinalArray += " \(word)"
                } else {
                    arrayOfSentence.append(stringToAddInFinalArray)
                    stringToAddInFinalArray = word
                }
            }
            if  counterArray == arrayOfWords.count {
                arrayOfSentence.append(stringToAddInFinalArray)
            }
        }
        
        print("Fin du Step 2: \(arrayOfSentence)")
        // Step 3 : Create a group of elements
        
        var arrayOfElement = [String]()
        var stringToAddinArrayOfElement = ""
        var counterArrayOfElement = 0
        for item in arrayOfSentence {
            counterArrayOfElement += 1
            if counterArrayOfElement == 1 {
                stringToAddinArrayOfElement = item
            } else {
                if item.last!.isUppercase && stringToAddinArrayOfElement.last!.isUppercase {
                    stringToAddinArrayOfElement += " \(item)"
                } else {
                    arrayOfElement.append(stringToAddinArrayOfElement)
                    stringToAddinArrayOfElement = item
                }
            }
            if counterArrayOfElement == arrayOfElement.count {
                arrayOfElement.append(stringToAddinArrayOfElement)
            }
        }
        print("Fin du Step 3: \(arrayOfElement)")
        
        return arrayOfElement
    }
    
    static func setTitleAuthorAndEditor(with arrayToSort : [String]){
        var counterTitle = 0
        var counterAuthor = 0
        var indexOfTitle = 0
        var indexOfAuthor = 0
        var numberOfWords = 0
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let smallWords = ["le","la","l'","du","des","les","en","par","et","pour"]
        
        // Title is the longer ?
        for item in arrayToSort {
            // separate string into words
            let components = item.components(separatedBy: chararacterSet)
            // remove empty string
            let words = components.filter { !$0.isEmpty }
            // test if there is a smallWords in the string
            if findIntersection(firstArray: words.map {$0.uppercased()}, secondArray: smallWords.map {$0.uppercased()}).isEmpty {
                print("no small word")
                if words.count > numberOfWords {
                    numberOfWords = words.count
                    indexOfTitle = counterTitle
                }
            } else {
                // There is a small word then probably the title of the book
                print("should be a title")
                indexOfTitle = counterTitle
                numberOfWords = words.count
            }
            counterTitle += 1
        }
        print("le titre du livre est : \(arrayToSort[indexOfTitle])")
         // Auhtor is the composed of 2 items ?
        for item in arrayToSort {
            let components = item.components(separatedBy: chararacterSet)
            let words = components.filter { !$0.isEmpty }
            if words.count == 2 {
                indexOfAuthor = counterAuthor
            }
            counterAuthor += 1
        }
         print("l'auteur du livre est : \(arrayToSort[indexOfAuthor])")
    }
}
