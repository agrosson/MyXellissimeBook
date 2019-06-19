//
//  ScanMenuViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 19/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit


// MARK: - Class ScanMenuViewController
/**
 This class defines the ScanMenuViewController
 
 This controller manages the beginning of the scan process as well as the export of isbn number found to AddManuallyViewController
 */
class ScanMenuViewController: UIViewController {
    
    // MARK: - Outlets and properties
    /// Scan Button
    lazy var scanButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("START SCANNING", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(scanIsbn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissCurrentView))
        view.addSubview(scanButton)
        setupScreen()
    }
    
    // MARK: - Methods
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setupScanButton()
    }
    
    /**
     Function that sets up scanButton
     */
    private func setupScanButton(){
        // need x and y , width height contraints
        scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        scanButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        scanButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    
    
    
    /**
     Function that launches the scan process
     */
    @objc func scanIsbn(){
        print("scan will start here !!")
    } /**
     Function that dismiss the view
     */
    @objc private func dismissCurrentView(){
        self.dismiss(animated: true, completion: nil)
    }
}
