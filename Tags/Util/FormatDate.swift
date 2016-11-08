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
  }
}

struct FormatDate {
  static let formatter = SingleFormatter()

  static func format(_ date: Date) -> String {
    return formatter.formatter.string(from: date)
  }
}
