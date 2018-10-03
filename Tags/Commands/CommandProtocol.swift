//
//  CommandProtocol.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-14.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

public struct DatePickerInfo {
  let usesDatePicker: Bool
  let dateOnly: Bool
}

public protocol CommandProtocol {
  var suggestionTitle: String { get }
  mutating func execute(data: Any)
  var datePickerInfo: DatePickerInfo { get }
  var listTitle: String { get }
}
