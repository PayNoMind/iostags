//
//  Reminder.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-14.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

struct Reminder: CommandProtocol {
  var suggestionTitle: String {
    return "reminder"
  }

  var usesDatePicker: Bool {
    return true
  }

  func execute() {
    print("Reminder Executed")
  }
}
