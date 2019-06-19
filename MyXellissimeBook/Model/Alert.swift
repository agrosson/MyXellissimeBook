//
//  Alert.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 19/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Class Alert
/**
 This class enables presentation of an alert what ever the viewController
 */
class Alert {
    // MARK: - Properties
    /// ViewController on which the alert will be displayed (self)
    var controller: UIViewController?
    /// Variable that tracks the case of alert
    var alertDisplay: AlertCase = .emailBadlyFormatted {
        didSet {
            presentAlert(alertCase: alertDisplay)
        }
    }
    /// Singleton Object
    static var shared = Alert()
    // MARK: - Enum
    /// Enum that lists all cases of alert presentations
    enum AlertCase {
        case    userEmailAlreadyUsedByAnotherUser,
        emailBadlyFormatted,
        passwordIsTooShort,
        noData,
        noUserRegistered,
        invalidPassword,
        googleBookDidNotFindAResult,
        googleBookAPIProblemWithUrl,
        bookDidNotFindAResult,
        needAllFieldsCompleted
    }
    // MARK: -
    init() {}
    // MARK: - Methods
    /**
     Function that presents an alert with defined text depending on AlertCase
     - Parameter alertCase: variable used to set text of the alert
     */
    private func presentAlert(alertCase: AlertCase) {
        switch alertCase {
        case .userEmailAlreadyUsedByAnotherUser: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.userEmailAlreadyUsedByAnotherUser,
            titleButton: "OK")
        case .emailBadlyFormatted: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.emailBadlyFormatted,
            titleButton: "OK")
        case .passwordIsTooShort: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.passwordIsTooShort,
            titleButton: "OK")
        case .noData: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.noData,
            titleButton: "OK")
        case .noUserRegistered: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.noUserRegistered,
            titleButton: "OK")
        case .invalidPassword: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.invalidPassword,
            titleButton: "OK")
        case .googleBookDidNotFindAResult: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.googleBookDidNotFindAResult,
            titleButton: "OK")
        case .googleBookAPIProblemWithUrl: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.googleBookAPIProblemWithUrl,
            titleButton: "OK")
        case .bookDidNotFindAResult: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.bookDidNotFindAResult,
            titleButton: "OK")
        case .needAllFieldsCompleted: controller?.presentAlertDetails(
            title: "Sorry",
            message: TextAndString.shared.needAllFieldsCompleted,
            titleButton: "Back")
        }
    }
}
// MARK: - Extension
extension UIViewController {
    /**
     Function that presents an alert
     */
    func presentAlertDetails(title: String, message: String, titleButton: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: titleButton, style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
/**
This Struct enables to list all texts of the application in a single file
*/
struct TextAndString {
    static let shared = TextAndString()
    let initialWarning = "This is the initial warning of the application. Please accept all users conditions!!"
    let conditionMustBeAccepted = "You can not use the application because you have not accepted the conditions yet"
    let userEmailAlreadyUsedByAnotherUser = "This email is already used by another user.\nPlease enter another Email."
    let emailBadlyFormatted = "This is not an Email.\nPlease enter a new Email"
    let passwordIsTooShort = "Enter password with minimum 6 characters"
    let noUserRegistered = "No user registered with this Email.\nPlease sign up"
    let invalidPassword = "Invalid password"
    let noData = "Fill all fields"
    let googleBookDidNotFindAResult = "No book found by Google Books. A new search will be launch with Open Library"
    let googleBookAPIProblemWithUrl = "URL problem with Google Books API."
    let bookDidNotFindAResult = "No book found in database. Please type down data"
    let needAllFieldsCompleted = "Fill in all fields please."
    
    // Segue
    let segueFromLogInToHome = "logInToWelcome"
    let segueToLogIn = "goToLogInScreen"
    let segueFromInitialToWelcome = "goToWelcomeScreen"
    let goToMyListOfBooksSegue = "goToMyListOfBooksSegue"
    // Cell identifier
    let myListOfBookCell = "myListOfBookCell"
}
