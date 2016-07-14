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
  func execute()
  var usesDatePicker: Bool { get }
}

extension CommandProtocol {
  var usesDatePicker: Bool {
    return false
  }
}
