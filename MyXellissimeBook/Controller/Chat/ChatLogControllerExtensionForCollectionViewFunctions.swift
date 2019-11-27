//
//  ChatLogControllerExtensionForCollectionViewFunctions.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 27/11/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase

extension ChatLogController {
    // MARK: - Methods - override func collectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        cell.backgroundColor = .clear
        cell.chatLogController = self
        let message = messages[indexPath.row]
        guard let text = message.text else {return UICollectionViewCell()}
        if  text != "" {
            cell.textView.isHidden = false
            cell.textView.text = text
            cell.bubbleWidthAnchor?.constant = estimateFrameFor(text: text).width + 25
        } else  {
            if let url = message.messageImageUrl {
                cell.messageImageView.loadingMessageImageUsingCacheWithisString(urlString: url)
                cell.textView.isHidden = true
                cell.bubbleWidthAnchor?.constant = 200
            }
        }
        setupCell(cell: cell, message: message)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 50
        let width = UIScreen.main.bounds.width
        
        let message = messages[indexPath.row]
        // let url = message.messageImageUrl
        let text = message.text
        guard let imageWidth = message.imageWidth else {return CGSize(width: 0, height: 0)}
        guard let imageHeight = message.imageHeight else {return CGSize(width: 0, height: 0)}
        
        if text != "" {
            guard let textToDisplay = text else {return CGSize(width: 0, height: 0)}
            height = estimateFrameFor(text: textToDisplay).height + 16
        }
        else {
            height = CGFloat(imageHeight/imageWidth * 200)
        }
        return CGSize(width: width, height: height)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
extension ChatLogController {
    // Custom zooming
    /**
     Function that will enable to zoom in a image
     - Parameter startingImageView: The  UIImageView to zoom in
     */
    func performZoomInForStartingImageView(startingImageView :UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView.isHidden = true
        // Get the frame of the picture we want to zoom in
        if let startingFrameSafe = startingImageView.superview?.convert(startingImageView.frame, to: nil) {
            self.startingFrame = startingFrameSafe
            // Create a new image view with this frame
            let zoomingImageView = UIImageView(frame: startingFrame!)
            // Set the image with original image
            zoomingImageView.image = startingImageView.image
            zoomingImageView.isUserInteractionEnabled = true
            zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            // Add the new imageView and create an animation
            if let keyWindow = UIApplication.shared.keyWindow {
                // create the black view behind and add the new imageView
                blackView = UIView(frame: keyWindow.frame)
                blackView.backgroundColor = .black
                blackView.alpha = 0
                keyWindow.addSubviews(blackView,zoomingImageView)
                // create an animation
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.blackView.alpha = 1
                    let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    zoomingImageView.center = keyWindow.center
                }, completion: nil)
            }
        }
    }
    /**
     Function that will enable to zoom out a image when tapped
     */
    @objc private func handleZoomOut(tapGesture: UITapGestureRecognizer){
        // Define the view tapped on
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.layer.masksToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                if let startingFrame = self.startingFrame {
                    zoomOutImageView.frame = startingFrame
                    self.blackView.alpha = 0
                }
            }) { (completed : Bool) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView.isHidden = false
            }
        }
    }
}
extension ChatLogController : UITextFieldDelegate {
    /**
     UITextFieldDelegate : defines how textFieldShouldReturn
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        inputTextField.resignFirstResponder()
        return true
    }
}
extension ChatLogController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     Delegate function get info from picker, get photo
     */
    func  imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("we pick a image")
        var selectedImageFromPicker = UIImage()
        // Get edited or originl image from picker
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else {
            guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
            selectedImageFromPicker = originalImage
        }
        let imageAsMessageName = UUID().uuidString
        FirebaseUtilities.saveImageAsMessage(imageAsMessage: selectedImageFromPicker, imageAsMessageName: imageAsMessageName)
        // get the sender Id
        guard let fromId = Auth.auth().currentUser?.uid else {return}
        guard let user = user else {return}
        let height = selectedImageFromPicker.size.height
        let width = selectedImageFromPicker.size.width
        FirebaseUtilities.saveMessageImage(messageImageUrl: imageAsMessageName, fromId: fromId, toUser: user, imageWidth: width, imageHeight: height)
        self.dismiss(animated: true) {
            self.attemptReloadData()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //DispatchQueue.main.async {self.collectionView.reloadData()}
        self.attemptReloadData()
        self.dismiss(animated: true, completion: nil)
    }
}
