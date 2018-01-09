//
//  Notifications.swift
//  Tags
//
//  Created by Tom Clark on 2017-12-09.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import UserNotifications

struct Notifications {
  static func createNotification(atDate date: Date) {
    let content = UNMutableNotificationContent()
    content.title = NSString.localizedUserNotificationString(forKey: "Fuck yall", arguments: nil)
    content.sound = .default()

    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute, .second], from: date)

    var dateInfo = DateComponents()
    dateInfo.second = (components.second ?? 0) + 15

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
    let request = UNNotificationRequest(identifier: "stuff", content: content, trigger: trigger)

    let center = UNUserNotificationCenter.current()
    center.add(request) { error in
      if let theError = error {
        print(theError.localizedDescription)
      }
    }
  }

  static func cancelNotification() {
    let center = UNUserNotificationCenter.current()

  }
}
