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
    static func textRecognizerFunction(image: UIImage, callBack: @escaping ([String]) -> Void) {
        let vision = Vision.vision()
        MyTextRecognizer.shared.textRecognizer = vision.onDeviceTextRecognizer()
        let imageVision = VisionImage(image: image)
        MyTextRecognizer.shared.textRecognizer.process(imageVision) { (features, error) in
            guard let features = features else {
                print("no text found on picture")
                return}
            var globalArray = [String]()
            for block in features.blocks {
                let blockText = block.text
                print("Paragraph \(blockText)")
                globalArray.append(blockText)
                for line in block.lines {
                    _ = line.text
                    for element in line.elements {
                        _ = element.text
                    }
                }
            }
            print("GlobalArrray = \(globalArray)")
            callBack(globalArray)
        }
    }
    
   static func setTitleAuthorAndEditor(with arrayToSort : [String]) -> (String, String){
        var counterTitle = 0
        var counterAuthor = 0
        var indexOfTitle = 0
        var indexOfAuthor = 0
        var numberOfWords = 0
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let smallWords = ["le","la","l'","du","des","les","en","par","et","pour","L\'","ou"]
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
    
        return (arrayToSort[indexOfTitle],arrayToSort[indexOfAuthor])
    }
}
