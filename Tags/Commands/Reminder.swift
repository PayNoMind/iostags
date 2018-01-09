//
//  Reminder.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-14.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

struct Reminder: CommandProtocol {
  var date: Date = Date()

  var suggestionTitle: String {
    return "reminder"
  }

  var usesDatePicker: Bool {
    return true
  }

  var listTitle: String {
    return suggestionTitle + " " + "\(FormatDate.format(date))"
  }

  mutating func execute(data: Any) {
    print("Reminder Executed")
    if let date = data as? Date {
      self.date = date
//      Notifications.createNotification(atDate: date)
    }
  }
}
