//
//  Tag.swift
//  Tags
//
//  Created by Tom Clark on 2017-08-24.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import Foundation

public enum Tag {
  case addTag
  case tag(String)
  case command(String, CommandProtocol?)

  public var value: String {
    switch self {
    case .addTag:
      return "Add Tag"
    case .tag(let title):
      return title
    case .command(let data):
      return data.0
    }
  }

  public var command: CommandProtocol? {
    switch self {
    case .command(let data):
      return data.1
    default:
      return nil
    }
  }

  public var isCommand: Bool {
    switch self {
    case .command:
      return true
    default:
      return false
    }
  }
}

extension Tag: Hashable {
  public var hashValue: Int {
    return self.value.hashValue &* 16777619
  }

  static public func == (left: Tag, right: Tag) -> Bool {
    return left.value == right.value
  }
}
