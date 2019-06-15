//
//  ChatLogController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 15/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatLogController: UICollectionViewController {
    
    // MARK: - Method - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Method - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
        setInputComponents()
    }
    
    func setInputComponents(){
        let inputsContainerView = UIView()
            inputsContainerView.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
            // do not forget
            inputsContainerView.translatesAutoresizingMaskIntoConstraints = false
            inputsContainerView.layer.cornerRadius = 5
        
            view.addSubview(inputsContainerView)
        // need x and y , width height contraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationItem.title = "ChatLog for \(InitialViewController.titleName)"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
