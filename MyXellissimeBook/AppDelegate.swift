//
//  AppDelegate.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 12/06/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import UIKit
import Firebase
// to setup Notification properties
import UserNotifications
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder {
    var window: UIWindow?
    
    
}

extension AppDelegate: UIApplicationDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // window configuration
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = CustomInitialTabBarController()
        
        // Firebase configuration
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false
       
        // Messaging Configuration
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        // Notifications Configuration
        attemptRegisterForNotifications(application: application)
        
        return true
    }

    // MARK: - Remote Notifications
    /// Get the token from APNS
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("Registered in APNS with Device Token: \(token)")
    }
    // Token from Firebase Messaging
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered in FCM with FCM Token: \(fcmToken)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
       
        // we verify we receive from payload dict with keys "text" and "image"
        guard let email = userInfo["email"] as? String else {
             print("email is not")
                // ignore Notification
                completionHandler(.noData)
                return
        }
        print("email is : \(email)")
    }
    
    
}
