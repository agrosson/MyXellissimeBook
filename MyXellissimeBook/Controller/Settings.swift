//
//  Settings.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 07/10/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Class InitialViewController
/**
 This class defines the InitialViewController
 */
class SettingsViewController: UIViewController {
    
    let containerView = CustomUI().view
    let modifyUserProfileImage = CustomUI().button
    let modifyUserPassword = CustomUI().button
    let modifyUserName = CustomUI().button
    let modifyUserEmail = CustomUI().button
    

    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(handelCancel))
        
        setupViews()
    }
    fileprivate func setupViews() {
        view.addSubview(containerView)
        containerView.addSubviews(modifyUserProfileImage,modifyUserPassword,modifyUserName,modifyUserEmail)
        containerView.backgroundColor? = .red
        NSLayoutConstraint.activate([
            // ContainerView
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    /**
     Action that dismisses VC when "Retour" button clicked
     */
    @objc private func handelCancel(){
        self.dismiss(animated: true, completion: nil)
    }
}
