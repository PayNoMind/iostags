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

    let uuid = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuid, content: content, trigger: trigger)

    let center = UNUserNotificationCenter.current()
    center.add(request) { error in
      if let theError = error {
        print(theError.localizedDescription)
      }
    }
  }

  static func cancelNotificationWithTitle(_ title: String) {
    let center = UNUserNotificationCenter.current()
    center.getPendingNotificationRequests { requests in

      for request in requests {
        if request.content.title == title {
          center.removePendingNotificationRequests(withIdentifiers: [request.identifier])
          break
        }
      }
    }
  }
}
