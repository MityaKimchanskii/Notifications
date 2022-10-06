//
//  ViewController.swift
//  Huli Pizza Notification
//
//  Created by Dmitrii Kim on 9/27/22.
//  Copyright © 2022 Dmitrii Kim. All rights reserved.
//

import UIKit
import UserNotifications

// a global constant
let pizzaSteps = ["Make pizza", "Roll Dough", "Add Sauce", "Add Cheese", "Add Ingredients", "Bake", "Done"]


class ViewController: UIViewController {
    var counter = 0
   
    @IBAction func schedulePizza(_ sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status = settings.authorizationStatus
            if status == .denied || status == .notDetermined {
                DispatchQueue.main.async {
                    self.accessDeniedAlert()
                }
                return
            }
//            self.introNotification()
            let content = UNMutableNotificationContent()
            content.title = "A Schedual Pizza"
            content.body = "Time to make a pizza!"
            
            var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
            dateComponents.second = dateComponents.second! + 15
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let identifier = "message.scheduled.\(Date().timeIntervalSinceReferenceDate)"
            self.addNotification(trigger: trigger, content: content, identifier: identifier)
        }
        
    }
    
    
    var pizzaNumber = 0
    @IBAction func makePizza(_ sender: UIButton) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status = settings.authorizationStatus
            if status == .denied || status == .notDetermined {
                DispatchQueue.main.async {
                    self.accessDeniedAlert()
                }
                return
            }
//            self.introNotification()
            self.pizzaNumber += 1
            
            let content = self.notificationContent(title: "A timed pizza step", body: "Making Pizza!")
            content.subtitle = "Pizza #\(self.pizzaNumber)"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
            
            let identifier = "message.pizza.\(self.pizzaNumber)"
            self.addNotification(trigger: trigger, content: content, identifier: identifier)
        }
        
    }
    
    func addNotification(trigger: UNNotificationTrigger, content: UNMutableNotificationContent, identifier: String) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            self.printError(error, location: "Add request for identifier" + identifier)
        }
    }
    
    func notificationContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = ["step": 0]
        return content
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.isNavigationBarHidden = true
    }

    //MARK: - Support Methods
    
    // A function to print errors to the console
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
    
    //A sample local notification for testing
    func introNotification(){
        
        // a Quick local notification.
        let time = 15.0
        counter += 1
        
        //Content
        let notifcationContent = UNMutableNotificationContent()
        notifcationContent.title = "Hello, Pizza!!"
        notifcationContent.body = "Just a message to test permissions \(counter)"
        notifcationContent.badge = counter as NSNumber
        
        //Trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        //Request
        let request = UNNotificationRequest(identifier: "intro", content: notifcationContent, trigger: trigger)
        
        //Schedule
        UNUserNotificationCenter.current().add(request) { (error) in
            self.printError(error, location: "Add introNotification")
        }
    }
    
    //An alert to indicate that the user has not granted permission for notification delivery.
    func accessDeniedAlert(){
        // presents an alert when access is denied for notifications on startup. give the user two choices to dismiss the alert and to go to settings to change thier permissions.
        let alert = UIAlertController(title: "Huli Pizza", message: "Huli Pizza needs notifications to work properly, but they are currently turned off. Turn them on in settings.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(okayAction)
        alert.addAction(settingsAction)
        present(alert, animated: true) {
        }
    }
}

