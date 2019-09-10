//
//  ApnsUploads.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 04/09/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import  UIKit
import UserNotifications


extension AppDelegate {
    
    /**
     This function registers the application for APNS
     - Parameter application: the current application to be registered
     */
    func attemptRegisterForNotifications(application: UIApplication){
        // Ask the user authorization for notification
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, _ in
            guard granted else {return}
            center.delegate = self
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
}
