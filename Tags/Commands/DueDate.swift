//
//  DueDate.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-26.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

struct DueDate: CommandProtocol {
  var date: Date = Date()

  var suggestionTitle: String {
    return "duedate"
  }

  var usesDatePicker: Bool {
    return true
  }

  var listTitle: String {
    return suggestionTitle + " " + "\(FormatDate.format(date))"
  }

  mutating func execute(data: Any) {
    if let date = data as? Date {
      self.date = date
//      Notifications.createNotification(atDate: date)
    }
  }
}
