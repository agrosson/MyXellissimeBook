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
import Firebase

extension AppDelegate: UNUserNotificationCenterDelegate {
    // allow notification in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    
    // this function is called when the notification is tapped on
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        let payload = response.notification.request.content
        guard let titre = payload.userInfo["email"] else {
            return
        }
        print("l'email est\(titre)" )
    }
}

