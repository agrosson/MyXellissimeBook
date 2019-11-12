//
//  Utilities.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 14/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase


/**
 Global properties, functions and extensions for the project
 */

/* Credits photo and icons
 <div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 
 <div>Icons made by <a href="https://www.flaticon.com/authors/good-ware" title="Good Ware">Good Ware</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 */


// MARK: - Global properties
let navStyles = UINavigationBar.appearance()
// This will set the color of the text for the back buttons.

let numbersOfLoansAndBorrowsAccepted = 6

/// Admin email
let adminEmail = "admin@xellissime.com"
/// Color for Navigation item
 let navigationItemColor = #colorLiteral(red: 0.2744090557, green: 0.4518461823, blue: 0.527189374, alpha: 1)
/// Color for backGround view
 let mainBackgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
/// Current screen height
let screenHeight = UIScreen.main.bounds.height
/// Current screen width
let screenWidth = UIScreen.main.bounds.width
/// This string to be used when user scan a new isbn
var scannedIsbn = ""
/// This bool to check if message comes from SearchBookDetailViewController
var messageFromSearch = false
/// List of french editors to be used in text recognizer activity
let editors = ["Le Livre de Poche", "Pocket", "J'AI LU", "Bayard","First Edition",
               "Hachette",
               "Seuil",
               "Larousse",
               "Gauthier-Villars",
               "Bordas",
               "Michelin",
               "Gallimard",
               "Flammarion",
               "Arthaud",
               "Nathan",
               "Dunod",
               "Ediscience",
               "Masson",
               "Presses Universitaires de France (PUF)",
               "Éditeurs français réunis",
               "Casterman",
               "Cerf",
               "Dargaud",
               "Delagrave",
               "Denoël",
               "Didier",
               "Magnard",
               "L'École des loisirs",
               "Eyrolles",
               "Fayard",
               "La Pensée universelle",
               "Fleurus",
               "Foucher",
               "Gautier-Languereau",
               "Hatier",
               "Istra",
               "Desclée de Brouwer",
               "Robert Laffont",
               "Fixot",
               "MDI",
               "Albin Michel",
               "Payot",
               "STOCK",
               "Bernard GRASSET",
               "Presses de la Cité",
               "PLON",
               "PERRIN",
               "Solar",
               "ARCHIMBAUD LE ROCHER",
               "France Loisirs",
               "Atlas",
               "ÉDITIONS SPINELLE",
               "ARTHAUD",
               "DIDIER & RICHARD",
               "Pierre BELFOND",
               "MERCURE DE FRANCE",
               "Loisirs GALLIMARD",
               "SUCCES DU LIVRE",
               "JC Lattès",
               "Phébus",
               "Éditions Féret",
               "le Monde",
               "Phébus",
               "le Monde"]

/// Track if new message during logout period
var newMessage = false
/// Track number of Interstitial
var counterInterstitial = 0
// MARK: - Global functions


func setupNavBarWithUser(user: User) -> UIView {
    let titleView = UIView()
    titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
    let containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    titleView.addSubview(containerView)
    containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
    containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
    let profileImageView = UIImageView()
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    profileImageView.contentMode = .scaleAspectFill
    profileImageView.layer.cornerRadius = 20
    profileImageView.clipsToBounds = true
    if let profileUrl = user.profileId {
        profileImageView.loadingImageUsingCacheWithUrlString(urlString: profileUrl)
    }
    containerView.addSubview(profileImageView)
    // Contraints X Y Width height
    profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    let nameLabel = UILabel()
    nameLabel.text = user.name
    nameLabel.textColor = navigationItemColor
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(nameLabel)
    // Contraints X Y Width height
    nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
    nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
    nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
    nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
    return titleView
}

func findIntersection (firstArray : [String], secondArray : [String]) -> [String]
{
    return [String](Set<String>(firstArray).intersection(secondArray))
}

// MARK: - CustomLabel class
/**
 This class enables to have insets in labels
 */
class CustomLabel: UILabel{
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)))
    }
}


