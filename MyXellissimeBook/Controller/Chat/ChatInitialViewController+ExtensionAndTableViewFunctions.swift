//
//  ChatInitialViewController+ExtensionAndTableViewFunctions.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 27/11/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleMobileAds

extension ChatInitialViewController {
    // MARK: - Methods - override func tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chatPartnerId = messages[indexPath.row].chatPartnerId() else {return}
        // first get the identifier of the parner user clicked
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            // a user is created and in chatlogController a function is called because a user is set
            let user = User()
            guard let name = dictionary["name"] as? String else {return}
            guard let email =  dictionary["email"] as? String else {return}
            guard let profileId =  dictionary["profileId"] as? String else {return}
            user.name = name
            user.email = email
            user.profileId = profileId
            self.showChatControllerForUser(user: user)
        }, withCancel: nil)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return typeOfDevice == "large" ? 120:100
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create a cell of type UserCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        // Get the message from the Array
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let message = self.messages[indexPath.row]
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let toId = message.chatPartnerId() else {return}
        Database.database().reference().child(FirebaseUtilities.shared.user_messages).child(uid).child(toId).removeValue { (error, ref) in
            if error != nil {
                print("Failed to remove  message:", error as Any)
                return
            }
            self.messagesDictionary.removeValue(forKey: toId)
            self.attemptReloadData()
        }
    }
}
extension ChatInitialViewController: GADInterstitialDelegate {
    // Manage Interstitials adds
    func createAndLoadInterstitial() -> GADInterstitial {
        // Interstitial real id
        //let interstitial = GADInterstitial(adUnitID: valueForAPIKey(named: "GADInterstitial"))
        // Interstitial test id
        let interstitial = GADInterstitial(adUnitID: valueForAPIKey(named: "testGADInterstitial"))
        interstitial.delegate = self
        perform(#selector(launchDelayInterstitial), with: nil, afterDelay: 1)
        return interstitial
    }
    @objc func launchInterstitial(){
        if interstitial.isReady && counterInterstitial < 1{
            interstitial.present(fromRootViewController: self)
            counterInterstitial += 1
        }
    }
    @objc func launchDelayInterstitial(){
        interstitial.load(GADRequest())
    }
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
    }
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
    }
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
    }
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
    }
}
