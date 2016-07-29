//
//  FormatDate.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-26.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

class SingleFormatter {
  static let sharedInstance = SingleFormatter()

  var formatter: NSDateFormatter

  private init() {
    formatter = NSDateFormatter()
    formatter.dateStyle = .MediumStyle
  }
}

struct FormatDate {
  static let formatter = SingleFormatter()

  static func format(date: NSDate) -> String {
    return formatter.formatter.stringFromDate(date)
  }
}
