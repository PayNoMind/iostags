//
//  DueDate.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-26.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

public struct DueDate: CommandProtocol {
  public var date: Date = Date()

  public var suggestionTitle: String {
    return "Date"
  }

  public var usesDatePicker: Bool {
    return true
  }

  public var listTitle: String {
    return suggestionTitle + " " + FormatDate.format(date, style: .none)
  }

  init() {}

  public init(date: Date) {
    self.date = date
  }

  public mutating func execute(data: Any) {
    if let date = data as? Date {
      self.date = date
    }
  }
}
