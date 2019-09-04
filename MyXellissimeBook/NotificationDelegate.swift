//
//  NotificationDelegate.swift
//  MyXellissimeBook
//
//  Created by ALEXANDRE GROSSON on 04/09/2019.
//  Copyright © 2019 GROSSON. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        let payload = response.notification.request.content
        guard let _ = payload.userInfo["MyXellissimeBook"]
            else { return }
        
        let chatInitialViewController = UINavigationController(rootViewController: ChatInitialViewController())
        self.window!.rootViewController!.present(chatInitialViewController, animated: true, completion: nil)
    }
}
