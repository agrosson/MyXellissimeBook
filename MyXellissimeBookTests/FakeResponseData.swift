//
//  FakeResponseData.swift
//  MyXellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 20/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation

class FakeResponseData {
    
    // instance of response OK - statusCode 200
    static let responseOK = HTTPURLResponse(url: URL(string: "aURL")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    // instance of response KO - statusCode not 200
    static let responseKO = HTTPURLResponse(url: URL(string: "aURL")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    // Creation of an error
    
    class NetworkError: Error {}
    static let error = NetworkError()
    // Retrieve correct datas to test for each API
    static var goodReadsCorrectData: Data? {
        // retrieve bundle where FakeWeatherResponseData is
        let bundle = Bundle(for: FakeResponseData.self)
        // retrieve url of file to test
        let url = bundle.url(forResource: "GoodReads", withExtension: "xml")!
        return try! Data(contentsOf: url)
    }
    static var googleBooksCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "GoogleBooks", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    static var openLibraryCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "OpenLibrary", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    // Creation of an incorrect datas
    static let goodReadsIncorrectData = "It's a goodReads error".data(using: .utf8)!
    static let googleBooksIncorrectData = "It's a googleBooks error".data(using: .utf8)!
    static let openLibraryIncorrectData = "It's a openLibrary error".data(using: .utf8)!
}
