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
        var globalArray = [[String]]()
        // print("Global text = \(features)")
        for block in features.blocks {
            let blockText = block.text
            //  print("Paragraph \(blockText)")
            let testArray = MyTextRecognizer.breakDown(of: blockText)
            globalArray.append(testArray)
            for line in block.lines {
                _ = line.text
               // print("Lines \(lineText)")
                for element in line.elements {
                    _ = element.text
               //     print("Characters \(elementText)")
                }
            }
        }
        for item in globalArray {
          print(item)
        }
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
        return arrayOfSentence
    }
}
