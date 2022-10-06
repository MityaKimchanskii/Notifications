//
//  NotificationCenterDelegate.swift
//  HuliPizzaNotifications
//
//  Created by Dmitrii Kim on 9/27/22.
//  Copyright © 2022 Dmitrii Kim. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge])
    }
   
    
    //MARK: - Support Methods
    let surferBullet = "🏄🏽‍♀️ "
    // A function to print errors to the console
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
}
