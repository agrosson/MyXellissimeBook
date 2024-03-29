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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Retour", style: .plain, target: self, action: #selector(dismissCurrentView))
        navigationItem.leftBarButtonItem?.tintColor = navigationItemColor
        let textAttributes = [NSAttributedString.Key.foregroundColor:navigationItemColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.title = "Ajouter un livre"
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
      //  navigationItem.title = InitialViewController.titleName
        //navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        setupaddWithScanButton()
        setupaddWithPhotoButton()
        setupactivityIndicator()
        setupaddManuallyButton()
    }
    
    
    func displayAlert() {
        Alert.shared.controller = self
        Alert.shared.alertDisplay = .noTextFoundOnBookCover
    }
    
    private func prepareToGetEditor(with array: [String]) -> String {
        var arrayForEditor = array.sorted(by: {$0.count > $1.count})
        print(arrayForEditor)
        while arrayForEditor.count > 3{
            arrayForEditor = arrayForEditor.dropLast()
        }
        print(arrayForEditor)
        var editor = ""
        for item in arrayForEditor {
            if item.contains("poche") || item.contains("Poche") || item.contains("POCHE"){
                editor = "Le Livre de Poche"
            }
        }
        if !editor.isEmpty {
            print(editor)
            return editor
        } else {
            print("l'éditeur est : \(self.getEditor(from: arrayForEditor, with: editors))")
            return self.getEditor(from: arrayForEditor, with: editors)
        }
    }
    
    /**
     Function that returns editor
     
     This function compares all the string received from textRecognizer with a list of editors and returns the editor with the lowest jaroWingler distance
     
     - Parameter itemScanned: array of string received from textRecognizer after photo of book cover
     - Parameter editors: list of editors
     - Returns: editor as a string
     */
    private func getEditor(from itemScanned : [String], with editors : [String]) -> String {
        // remove string with single element
        let newArray = itemScanned.filter ({ $0.count != 1})
        var score: Float = 0
        var countWords = 0
        var countEditor = 0
        var indiceEditor = 0
        for item in newArray {
            for editor in editors {
                let distance = String.jaroWinglerDistance(item.uppercased(), editor.uppercased())
                if distance > score && item.count != 1 {
                    score = distance
                    indiceEditor = countEditor
                }
                countEditor += 1
            }
            countWords += 1
            countEditor = 0
        }
        return editors[indiceEditor]
    }
    
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
            UIAlertController(title: "Couverture du livre",
                              message: nil,
                              preferredStyle: .alert)
        
        // 2
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(
                title: "Prendre une photo",
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
        
        // 4
        let cancelButton = UIAlertAction(title: "Annuler", style: .cancel) { (alert) -> Void in
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
    @objc func scanIsbn(){
        let scanMenuViewController = UINavigationController(rootViewController: ScanMenuViewController())
        scanMenuViewController.modalPresentationStyle = .fullScreen
        present(scanMenuViewController, animated: true, completion: nil)
    }
    /**
     Function that presents imagePicker via UIAlert
     */
    @objc func takePhoto(){
        let alertVC = UIAlertController(title: "Cher Utilisateur", message: "Merci de prendre la photo en mode paysage", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default) { (alert) -> Void in
            print("on est ici")
            self.presentPhotoAlert()
        })
        present(alertVC, animated: true, completion: nil)
    }
    /**
     Function that presents addManually ViewController
     */
    @objc func addManually(){
        print("go to add manually")
        let addManuallyViewController = UINavigationController(rootViewController: AddManuallyViewController())
        addManuallyViewController.modalPresentationStyle = .fullScreen
        present(addManuallyViewController, animated: true, completion: nil)
    }
    
    private func activeLabelsForDragAndDrop(with book: Book) {
            // to do : Alert to explain the drag and drop principle
            let addManually = AddManuallyViewController()
            addManually.bookToSave = book
            addManually.bookElementFromPhoto = true
            addManually.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(addManually, animated: true)
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
            // Get info from picture with recognizer
            MyTextRecognizer.textRecognizerFunction(image: image, callBack: { (array) in
                print(array)
                // Get title and Author from picture
                let titleAndAuthor = MyTextRecognizer.setTitleAuthorAndEditor(with: array)
                // Get editor from Jaro-Wringler algorithm
                let editor = self.prepareToGetEditor(with: array)
                let title = titleAndAuthor.0
                let author = titleAndAuthor.1
                let bookToSendToManually = Book()
                bookToSendToManually.author = author
                bookToSendToManually.title = title
                bookToSendToManually.editor = editor
                let isbn = UUID().uuidString
                bookToSendToManually.isbn = isbn
                bookToSendToManually.coverURL = isbn
                guard let imageRotated = image.rotate(radians: -.pi/2) else {return}
                FirebaseUtilities.saveCoverImage(coverImage: imageRotated, isbn: isbn)
                self.activeLabelsForDragAndDrop(with: bookToSendToManually)

            })
        }
    }
}

