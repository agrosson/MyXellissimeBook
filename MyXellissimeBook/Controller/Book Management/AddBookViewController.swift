//
//  AddBookViewController.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 14/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices


// MARK: - Class AddBookViewController
/**
 This class defines the AddBookViewController
 */
class AddBookViewController: UIViewController {
    // MARK: - Outlets and properties
    // create button
    /// Add with scan Button
    lazy var addWithScanButton = CustomUI().button
    /// Add With a photo Button
    lazy var addWithPhotoButton = CustomUI().button
    /// ActivityIndicator
    var activityIndicator = CustomUI().activityIndicatorView
    /// Add manually Button
    lazy var addManuallyButton = CustomUI().button
    
    /// Declaration of VisionTextRecognizer
    var textRecognizer = MyTextRecognizer.shared.textRecognizer
    
    
    // MARK: - Method viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissCurrentView))
        view.addSubview(addWithScanButton)
        view.addSubview(addWithPhotoButton)
        view.addSubview(activityIndicator)
        view.addSubview(addManuallyButton)
        setupScreen()
        
    }
    
    
    // MARK: - Method viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super .viewWillAppear(animated)
        setupScreen()
    }
    // MARK: - Methods

    /**
     Function that setup screen
     */
    private func setupScreen(){
        view.backgroundColor = #colorLiteral(red: 0.3353713155, green: 0.5528857708, blue: 0.6409474015, alpha: 1)
        navigationItem.title = InitialViewController.titleName
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setupaddWithScanButton()
        setupaddWithPhotoButton()
        setupactivityIndicator()
        setupaddManuallyButton()
    }
    /**
     Function that sets up addWithScanButton
     */
    private func setupaddWithScanButton(){
        addWithScanButton.setTitle("Scan a book Isbn", for: .normal)
        addWithScanButton.layer.cornerRadius = 15
        addWithScanButton.layer.borderColor  = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addWithScanButton.addTarget(self, action: #selector(scanIsbn), for: .touchUpInside)
        // need x and y , width height contraints
        addWithScanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addWithScanButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        addWithScanButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addWithScanButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    
    /**
     Function that sets up addWithPhotoButton
     */
    private func setupaddWithPhotoButton(){
        addWithPhotoButton.layer.cornerRadius = 15
        addWithPhotoButton.setTitle("Take a picture of the book", for: .normal)
        addWithPhotoButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        // need x and y , width height contraints
        addWithPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addWithPhotoButton.topAnchor.constraint(equalTo: addWithScanButton.bottomAnchor, constant: 30).isActive = true
        addWithPhotoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addWithPhotoButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
    /**
     Function that sets up activityIndicator
     */
    private func setupactivityIndicator(){
        activityIndicator.centerXAnchor.constraint(equalTo: addWithPhotoButton.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: addWithPhotoButton.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    /**
     Function that sets up addManuallyButton
     */
    private func setupaddManuallyButton(){
        addManuallyButton.setTitle("Add manually", for: .normal)
        addManuallyButton.layer.cornerRadius = 15
        addManuallyButton.addTarget(self, action: #selector(addManually), for: .touchUpInside)
        // need x and y , width height contraints
        addManuallyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addManuallyButton.topAnchor.constraint(equalTo: addWithPhotoButton.bottomAnchor, constant: 30).isActive = true
        addManuallyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addManuallyButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
    }
//    /**
//     Function that initializes all steps in viewDidLoad
//     */
//    private func textRecognizerFunction(image: UIImage){
//        let vision = Vision.vision()
//        textRecognizer = vision.onDeviceTextRecognizer()
//        runTextRecognition(with: image)
//    }
    /**
     Function that presents imagePicker
     The image picked will be used in the text recognizer function.
     Text will be extracted and analysed
     */
    private func presentPhotoAlert(){
        self.activityIndicator.isHidden = false
        print("will take a picture of the book to extract data ")
        // 1
        let imagePickerActionSheet =
            UIAlertController(title: "Snap/Upload Image",
                              message: nil,
                              preferredStyle: .actionSheet)
        
        // 2
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(
                title: "Take Photo",
                style: .default) { (alert) -> Void in
                    self.activityIndicator.isHidden = false
                    // 1
                    self.activityIndicator.startAnimating()
                    // 2
                    let imagePicker = UIImagePickerController()
                    // 3
                    imagePicker.delegate = self
                    // 4
                    imagePicker.sourceType = .camera
                    // 5
                    imagePicker.mediaTypes = [kUTTypeImage as String]
                    // 6
                    self.present(imagePicker, animated: true, completion: {
                        // 7
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                    })
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        
        // 3
        let libraryButton = UIAlertAction(
            title: "Choose Existing",
            style: .default) { (alert) -> Void in
                
                // TODO: Add more code here...
        }
        imagePickerActionSheet.addAction(libraryButton)
        
        // 4
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (alert) -> Void in
            self.activityIndicator.isHidden = true
        }
        imagePickerActionSheet.addAction(cancelButton)
        
        // 5
        present(imagePickerActionSheet, animated: true)
    }
    // MARK: - Methods @objc - Actions
    @objc private func dismissCurrentView(){
        self.dismiss(animated: true, completion: nil)
    }
    /**
     Function that presents scanMenuViewController ViewController
     */
    @objc private func scanIsbn(){
        let scanMenuViewController = UINavigationController(rootViewController: ScanMenuViewController())
        present(scanMenuViewController, animated: true, completion: nil)
    }
    /**
     Function that presents imagePicker via UIAlert
     */
    @objc private func takePhoto(){
        presentPhotoAlert()
    }
    /**
     Function that presents addManually ViewController
     */
    @objc private func addManually(){
        print("go to add manually")
        let addManuallyViewController = UINavigationController(rootViewController: AddManuallyViewController())
        present(addManuallyViewController, animated: true, completion: nil)
    }

    
    
    
}
// MARK: - UINavigationControllerDelegate
extension AddBookViewController: UINavigationControllerDelegate {
}

// MARK: - UIImagePickerControllerDelegate
extension AddBookViewController: UIImagePickerControllerDelegate {
    /**
     Function that tells the delegate that the user picked a still image or movie and set the image picked as the photo to display on image view choosen.
     */
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // What to do when operation is done
        picker.dismiss(animated: true) {
            print("do something with the image: send the recognizer")
            MyTextRecognizer.textRecognizerFunction(image: image)
            
        }
    }
}

