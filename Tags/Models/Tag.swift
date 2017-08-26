//
//  Tag.swift
//  Tags
//
//  Created by Tom Clark on 2017-08-24.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import Foundation

enum Tag {
  case addTag
  case tag(String)

  var value: String {
    switch self {
    case .addTag:
      return "Add Tag"
    case .tag(let title):
      return title
    }
  }
}
