//
//  CommandProtocol.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-14.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

public protocol CommandProtocol {
  var suggestionTitle: String { get }
  mutating func execute(data: Any)
  var usesDatePicker: Bool { get }
  var listTitle: String { get }
}

extension CommandProtocol {
  var usesDatePicker: Bool {
    return false
  }
}
