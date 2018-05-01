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

  var formatter: DateFormatter

  fileprivate init() {
    formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.doesRelativeDateFormatting = true
  }
}

struct FormatDate {
  static func format(_ date: Date, style: DateFormatter.Style = .medium) -> String {
    SingleFormatter.sharedInstance.formatter.timeStyle = style
    return SingleFormatter.sharedInstance.formatter.string(from: date)
  }
}
