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
 This class enables presentation of an alert whatever the viewController
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
        needAllFieldsCompleted,
        noUserFound,
        unableToCreateUser,
        noTitleForBook,
        needAtLeastOneField,
        noTextFoundOnBookCover,
        noBookForUSer,
        updateProfileImage,
        noUserFoundForLoan,
        noMessageForUSer,
        conditionMustBeAccepted
    }
    // MARK: - Initializer
    init() {}
    // MARK: - Methods
    /**
     Function that presents an alert with defined text depending on AlertCase
     - Parameter alertCase: variable used to set text of the alert
     */
    private func presentAlert(alertCase: AlertCase) {
        switch alertCase {
        case .userEmailAlreadyUsedByAnotherUser: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.userEmailAlreadyUsedByAnotherUser,
            titleButton: "OK")
        case .emailBadlyFormatted: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.emailBadlyFormatted,
            titleButton: "OK")
        case .passwordIsTooShort: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.passwordIsTooShort,
            titleButton: "OK")
        case .noData: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.noData,
            titleButton: "OK")
        case .noUserRegistered: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.noUserRegistered,
            titleButton: "OK")
        case .invalidPassword: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.invalidPassword,
            titleButton: "OK")
        case .googleBookDidNotFindAResult: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.googleBookDidNotFindAResult,
            titleButton: "OK")
        case .googleBookAPIProblemWithUrl: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.googleBookAPIProblemWithUrl,
            titleButton: "OK")
        case .bookDidNotFindAResult: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.bookDidNotFindAResult,
            titleButton: "OK")
        case .needAllFieldsCompleted: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.needAllFieldsCompleted,
            titleButton: "Retour")
        case .noUserFound: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.noUserFound,
            titleButton: "Retour")
        case .unableToCreateUser: controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.unableToCreateUser,
            titleButton: "Retour")
        case .noTitleForBook : controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.noTitleForBook,
            titleButton: "Retour")
        case .needAtLeastOneField : controller?.presentAlertDetails(
            title: "Désolé",
            message: TextAndString.shared.needAtLeastOneField,
            titleButton: "Retour")
        case .noTextFoundOnBookCover : controller?.presentAlertDetails(
            title: "Cher Utilisateur,",
            message: TextAndString.shared.noTextFoundOnBookCover,
            titleButton: "Retour")
        case .noBookForUSer : controller?.presentAlertDetails(
            title: "Cher Utilisateur,",
            message: TextAndString.shared.noBookForUSer,
            titleButton: "Retour")
        case .updateProfileImage : controller?.presentAlertDetails(
            title: "Cher Utilisateur,",
            message: TextAndString.shared.updateProfileImage,
            titleButton: "Retour")
        case .noUserFoundForLoan : controller?.presentAlertDetails(
            title: "Cher Utilisateur,",
            message: TextAndString.shared.noUserFoundForLoan,
            titleButton: "Retour")
        case .noMessageForUSer : controller?.presentAlertDetails(
            title: "Cher Utilisateur,",
            message: TextAndString.shared.noMessageForUSer,
            titleButton: "Retour")
        case .conditionMustBeAccepted : controller?.presentAlertDetails(
            title: "Cher Utilisateur,",
            message: TextAndString.shared.conditionMustBeAccepted,
            titleButton: "Retour")
        }
    }
}

/**
 This Struct enables to list all texts of the application in a single file
 */
struct TextAndString {
    static let shared = TextAndString()
    let initialWarning = "Vous devez accepter les conditions générales pour utiliser l'application"
    let conditionMustBeAccepted = "Vous ne pouvez pas utiliser l'application car vous n'avez pas encore accepté les conditions générales"
    let userEmailAlreadyUsedByAnotherUser = "Cet email est déjà utilisé par une autre personne.\nMerci de choisir un autre email."
    let emailBadlyFormatted = "Ceci n'est pas un email.\nMerci d'entrer un autre email"
    let passwordIsTooShort = "Le mot de passe doit contenir au moins 6 caractères"
    let noUserRegistered = "Aucun utilisateur enregistré avec cet email.\nMerci de vous inscrire"
    let invalidPassword = "Mot de passe invalide"
    let noData = "Merci de remplir tous les champs"
    let googleBookDidNotFindAResult = "Aucun livre trouvé dans Google Books. Une nouvelle recherche va être lancée avec Open Library"
    let googleBookAPIProblemWithUrl = "Il y a un problème avec l'API de Google Books."
    let bookDidNotFindAResult = "Aucun livre n'a été trouvé.\nMerci de saisir les données manuellement"
    let needAllFieldsCompleted = "Merci de remplir tous les champs"
    let noUserFound = "Aucun utilisateur trouvé avec cet email et/ou mot de passe"
    let noUserFoundForLoan = "Aucun utilisateur trouvé avec cet email"
    let unableToCreateUser = "L'utilisateur n'a pas été créé.\nMerci d'essayer une nouvelle fois"
    let noTitleForBook = "Merci d'indiquer le titre du livre"
    let needAtLeastOneField = "Merci de saisir au moins un élément"
    let noTextFoundOnBookCover = "Aucun texte n'a été trouvé.\nMerci d'essayer en mode paysage"
    let noBookForUSer = "Vous n'avez aucun livre pour l'instant.\nPour ajouter un livre, cliquer sur le bouton <ajouter> en haut à droite"
    let noMessageForUSer = "Vous pouvez écrire un message en cliquant sur l'icône en haut à droite"
    let updateProfileImage = "Vous pouvez changer la photo de votre profil en tappant sur l'image du livre"
}
