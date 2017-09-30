//
//  Array+Set.swift
//  Tags
//
//  Created by Tom Clark on 2017-08-31.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import Foundation

extension Array where Element == Tag {
  var toSet: Set<Tag> {
    return Set<Tag>(self)
  }

  var toStringSet: Set<String> {
    return Set<String>(self.map { $0.value })
  }
}

extension Set where Element == String {
  public var toArray: [String] {
    return [String](self)
  }
}

extension Set where Element == Tag {
  var toArray: [Tag] {
    return [Tag](self)
  }

  var toStringArray: [String] {
    return self.map { $0.value }
  }
}

extension Array where Element == String {
  var toTagArray: [Tag] {
    return self.map { Tag.tag($0) }
  }
}
