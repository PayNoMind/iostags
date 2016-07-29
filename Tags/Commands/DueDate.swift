//
//  DueDate.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-26.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

struct DueDate: CommandProtocol {
  var suggestionTitle: String {
    return "duedate"
  }

  var usesDatePicker: Bool {
    return true
  }

  func execute() {
    print("Reminder Executed")
  }
}
