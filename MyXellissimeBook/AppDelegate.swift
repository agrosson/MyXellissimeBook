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

@UIApplicationMain
class AppDelegate: UIResponder {
    var window: UIWindow?
    
    // A persistent container to save datas
    /*
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PushNotifications")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    */
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase configuration
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = false
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = CustomInitialTabBarController()
        //let vc = nc.topViewController as! NotificationTableViewController
      //  vc.managedObjectContext = persistentContainer.viewContext
      
        
        // Ask the user authorization for notification
        registerForPushNotifications(application: application)
        

        
        return true
    }
    
    // MARK: - Remote Notifications
    /// Get the token from APNS
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("Device Token: \(token)")
    }
}
