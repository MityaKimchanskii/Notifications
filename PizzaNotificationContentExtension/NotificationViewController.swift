//
//  NotificationViewController.swift
//  PizzaNotificationContentExtension
//
//  Created by Mitya Kim on 10/6/22.
//  Copyright © 2022 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentSubtitle: UILabel!
    @IBOutlet weak var contentBody: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    var content = UNMutableNotificationContent()
    
    var requestIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    let unLikeAction = UNNotificationAction(identifier: "unlike", title: "Unlike", options: [])
    let likeAction = UNNotificationAction(identifier: "like", title: "Like", options: [])
    let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Snooze 5 Seconds", options: [])
    
    @IBAction func snoozeButtonTapped(_ sender: UIButton) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
       
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            
        }
        
        extensionContext?.dismissNotificationContentExtension()
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Like" {
            sender.setTitle("Unlike", for: .normal)
            
            extensionContext?.notificationActions = [snoozeAction, unLikeAction]
            
        } else {
            sender.setTitle("Like", for: .normal)
            
            extensionContext?.notificationActions = [snoozeAction, likeAction]
        }
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
        let action = response.actionIdentifier
        
        if action == "like" {
            extensionContext?.notificationActions = [snoozeAction, unLikeAction]
        }
        
        if action == "unlike" {
            extensionContext?.notificationActions = [snoozeAction, likeAction]
        }
        
        if action == "snooze" {
            completion(.dismissAndForwardAction)
        }
        
        completion(.doNotDismiss)
    }
    
    func didReceive(_ notification: UNNotification) {
        
        requestIdentifier = notification.request.identifier
        
        content = notification.request.content.mutableCopy() as! UNMutableNotificationContent
        contentTitle.text = content.title
        contentSubtitle.text = content.subtitle
        contentBody.text = content.body
        
        extensionContext?.notificationActions = [snoozeAction, likeAction]
    }

}
