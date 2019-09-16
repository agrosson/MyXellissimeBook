//
//  ExtensionViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 13/08/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit


// MARK: - extension UIViewController
extension UIViewController {
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    /**
     Function that presents an alert
     */
    func presentAlertDetails(title: String, message: String, titleButton: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: titleButton, style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
