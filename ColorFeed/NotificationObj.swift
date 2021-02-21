//
//  NotificationObj.swift
//  ColorFeed
//
//  Created by Comp 631C on 21/2/2021.
//  Copyright © 2021 Apple. All rights reserved.
//

//
//  NotificationObj.swift
//  bustepdev
//
//  Created by Comp 631C on 17/12/2020.
//  Copyright © 2020 COMP Dev. All rights reserved.
//

import Foundation
import UserNotifications
class NotificationObj{
    static func bgTaskNotification(){
        let center = UNUserNotificationCenter.current()
        let identifyForNotification = UUID().uuidString
        let content = UNMutableNotificationContent()
        content.title = "BGTask Run"
        content.body = "The background task for checkout validation is running."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 , repeats: false)
        let request = UNNotificationRequest(identifier: identifyForNotification, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: {(_ error: Error?) -> Void in
            if error == nil {
                print("bgTaskNotification add Notification Request succeeded!")
            }
        })
    }
    static func bgTaskRegisterNotification(){
        let center = UNUserNotificationCenter.current()
        let identifyForNotification = UUID().uuidString
        let content = UNMutableNotificationContent()
        content.title = "BGTask Register"
        content.body = "The background task is registered."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 , repeats: false)
        let request = UNNotificationRequest(identifier: identifyForNotification, content: content, trigger: trigger)

        center.add(request, withCompletionHandler: {(_ error: Error?) -> Void in
            if error == nil {
                print("bgTaskRegisterNotification add Notification Request succeeded!")
            }
        })
    }
}
