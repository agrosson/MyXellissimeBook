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
        button.setTitle("LANCER LE SCAN", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(scanIsbn), for: .touchUpInside)
        return button
    }()
    
    /// Container View for isbn label and export button
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        // do not forget
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Scan Button
    lazy var exportButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.clear
        button.setTitle("Exporter l'ISBN", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(exportIsbn), for: .touchUpInside)
        return button
    }()
    //Label that wil display the isbn
    let isbnLabel: CustomLabel = {
        let label = CustomLabel()
        label.backgroundColor = UIColor.clear
        // do not forget
        label.text = "Le numéro ISBN va être affiché ici"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 2
        label.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.adjustsFontSizeToFitWidth = true
        label.contentScaleFactor = 0.5
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem?.tintColor = navigationItemColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:navigationItemColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Scanner un ISBN"
        view.addSubview(scanButton)
        view.addSubview(containerView)
        containerView.addSubview(exportButton)
        containerView.addSubview(isbnLabel)
        containerView.isHidden = false
        setupScreen()
        switchDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switchDisplay()
    }
    
    // MARK: - Methods
    
    
    private func switchDisplay() {
        
       print("test switch with isbn \(scannedIsbn)")
        if scannedIsbn == "" {
            containerView.isHidden = true
            scanButton.isHidden = false
        } else {
            containerView.isHidden = false
            scanButton.isHidden = true
        }
        isbnLabel.text = "Numéro ISBN: \(scannedIsbn)"
      //  scannedIsbn = ""
    }
    
    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
      //  navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setupScanButton()
        setupContainerView()
        setupExportButton()
        setupIsbnLabel()
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
     Function that sets up scanButton
     */
    private func setupContainerView(){
        // need x and y , width height contraints
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up scanButton
     */
    private func setupExportButton(){
        // need x and y , width height contraints
        exportButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        exportButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        exportButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        exportButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    }
    
    /**
     Function that sets up scanButton
     */
    private func setupIsbnLabel(){
        // need x and y , width height contraints
        isbnLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        isbnLabel.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        isbnLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        isbnLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
    }
    
    /**
     Function that launches the scan process
     */
    @objc func exportIsbn(){
        let addManuallyViewController = UINavigationController(rootViewController: AddManuallyViewController())
        present(addManuallyViewController, animated: true, completion: nil)
    }

    /**
     Function that launches the scan process
     */
    @objc func scanIsbn(){
        let scanRunningViewController = UINavigationController(rootViewController: ScanRunningViewController())
        present(scanRunningViewController, animated: true, completion: nil)
        
    } /**
     Function that dismiss the view
     */
    @objc private func dismissCurrentView(){
        self.dismiss(animated: true, completion: nil)
    }
}
