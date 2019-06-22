//
//  ManageLoanViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 22/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase


// MARK: - Class ManageLoanViewController
/**
 This class enables to create and manage book laon
 */
class ManageLoanViewController: UIViewController {
    // MARK: - Properties
    /// The book to lend
    var bookToLend: Book?
    /// Current user uid
    var userUid: String? = {
       return Auth.auth().currentUser?.uid
    }()
    var userBorrower = User()
    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
