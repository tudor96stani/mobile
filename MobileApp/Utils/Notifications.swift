//
//  Notifications.swift
//  MobileApp
//
//  Created by Tudor Stanila on 02/01/2018.
//  Copyright © 2018 Tudor Stanila. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationClient {
    static func Send(title:String,body:String,badge:Int,timeInt:Int,identifier:String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = badge as NSNumber
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInt), repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
