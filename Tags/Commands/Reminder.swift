//
//  Reminder.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-14.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

public struct Reminder: CommandProtocol {
  public var date: Date = Date()

  public var suggestionTitle: String {
    return "reminder"
  }

  public var usesDatePicker: Bool {
    return true
  }

  public var listTitle: String {
    return suggestionTitle + " " + "\(FormatDate.format(date))"
  }

  public mutating func execute(data: Any) {
    print("Reminder Executed")
    if let date = data as? Date {
      self.date = date
      Notifications.createNotification(atDate: date)
    }
  }
}
