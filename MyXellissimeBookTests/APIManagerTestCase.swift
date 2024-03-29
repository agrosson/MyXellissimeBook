//
//  APIManagerTestCase.swift
//  MyXellissimeBookTests
//
//  Created by ALEXANDRE GROSSON on 20/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import XCTest
@testable import MyXellissimeBook
@testable import FirebaseCore

class APIManagerTestCase: XCTestCase {

   
    /*******************************************************
     Block for testing GoogleBooks API
     ********************************************************/
    func testGoogleBooksShouldPostFailedCallbackIfError() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: nil, response: nil, error:FakeResponseData.error)
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: nil, response: nil, error: nil  )
        apiManager.getBookInfoGoodReads = URLSessionFake(data: nil, response: nil, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfo(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9780552565974", callBack:  { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
        }
    
    func testGoogleBooksShouldPostFailedCallbackIfnoData() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil)
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: nil, response: nil, error: nil  )
        apiManager.getBookInfoGoodReads = URLSessionFake(data: nil, response: nil, error: nil)
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfo(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9780552565974", callBack:  { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }
 
    func testGoogleBooksShouldPostFailedCallbackIfResponseKO() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: FakeResponseData.googleBooksIncorrectData, response: nil, error: nil)
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: nil, response: nil, error: nil  )
        apiManager.getBookInfoGoodReads = URLSessionFake(data: nil, response: nil, error: nil)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfo(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9780552565974", callBack:  { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGoogleBooksShouldPostFailedCallbackIfResponseOKNoErrorDataIncorrect() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: FakeResponseData.googleBooksIncorrectData, response: FakeResponseData.responseOK, error: nil)
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: nil, response: nil, error: nil  )
        apiManager.getBookInfoGoodReads = URLSessionFake(data: nil, response: nil, error: nil)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfo(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9780552565974", callBack:  { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)

    }

    func testGoogleBooksShouldPassCallbackIfCorrectDataAndNoError() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: FakeResponseData.googleBooksCorrectData, response: FakeResponseData.responseOK, error: nil)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfo(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9780552565974", callBack:  { (success, book) in
            XCTAssertTrue(success)
            XCTAssertNotNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }
    
    /*******************************************************
     Block for testing OpenLibrary API
     ********************************************************/
    
    func testOpenLibraryShouldPostFailedCallbackIfError() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBooKInfoFromGoogleBooks = URLSessionFake(data: nil, response: nil, error: nil)
        apiManager.getBookInfoOpenLibrary = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error  )
        apiManager.getBookInfoGoodReads = URLSessionFake(data: nil, response: nil, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoOpenLibrary(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9782070377220", callBack: { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }

   
    
    func testOpenLibraryShouldPostFailedCallbackIfNoData() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBookInfoOpenLibrary = URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoOpenLibrary(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9782070377220", callBack: { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testOpenLibraryShouldPostFailedCallbackIfResponseKO() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBookInfoOpenLibrary = URLSessionFake(data: FakeResponseData.openLibraryCorrectData, response: FakeResponseData.responseKO, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoOpenLibrary(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9782070377220", callBack: { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testOpenLibraryShouldPostFailedCallbackIfResponseOKButIncorrectData() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBookInfoOpenLibrary = URLSessionFake(data: FakeResponseData.openLibraryIncorrectData, response: FakeResponseData.responseOK, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoOpenLibrary(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9782070377220", callBack: { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }
   
    func testOpenLibraryShouldPostPassCallbackIfResponseOKNoErrorAndCorrectData() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBookInfoOpenLibrary = URLSessionFake(data: FakeResponseData.openLibraryCorrectData, response: FakeResponseData.responseOK, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoOpenLibrary(fullUrl: URL(string: "nil")!, method: "nil", isbn: "9782070377220", callBack: { (success, book) in
            XCTAssertTrue(success)
            XCTAssertNotNil(book)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    /*******************************************************
     Block for testing GoodReads API
     ********************************************************/
    

    func testGoodReadsShouldPostFailedCallbackIfError() {
        // Given
         let apiManager  = APIManager()
        apiManager.getBookInfoGoodReads = URLSessionFake(data: nil, response: nil, error: FakeResponseData.error)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoGoodReads(fullUrl: URL(string: "nil")!, method:"nil", isbn: "9782746518834", callBack: { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGoodReadsShouldPostFailedCallbackIfNodata() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBookInfoGoodReads = URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoGoodReads(fullUrl: URL(string: "nil")!, method:"nil", isbn: "9782746518834", callBack: { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }
    
   
    func testGoodReadsShouldPostFailedCallbackIfResponseKO() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBookInfoGoodReads = URLSessionFake(data: FakeResponseData.goodReadsCorrectData, response: FakeResponseData.responseKO, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoGoodReads(fullUrl: URL(string: "nil")!, method:"nil", isbn: "9782746518834", callBack: { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }

    func testGoodReadsShouldPostFailedCallbackIfResponseOKbutIncorrectData() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBookInfoGoodReads = URLSessionFake(data: FakeResponseData.goodReadsIncorrectData, response: FakeResponseData.responseOK, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoGoodReads(fullUrl: URL(string: "nil")!, method:"nil", isbn: "9782746518834", callBack: { (success, book) in
            XCTAssertFalse(success)
            XCTAssertNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }
    func testGoodReadsShouldPostPassCallbackIfResponseOKNoErrorAndCorrectData() {
        // Given
        let apiManager  = APIManager()
        apiManager.getBookInfoGoodReads = URLSessionFake(data: FakeResponseData.goodReadsCorrectData, response: FakeResponseData.responseOK, error: nil)
        // When
        let expectation = XCTestExpectation(description: "Wait for queue GoogleBooks.")
        apiManager.getBookInfoGoodReads(fullUrl: URL(string: "nil")!, method:"nil", isbn: "9782746518834", callBack: { (success, book) in
            XCTAssertTrue(success)
            XCTAssertNotNil(book)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.1)
    }
}
