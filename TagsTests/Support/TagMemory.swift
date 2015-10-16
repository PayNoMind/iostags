//
//  TagMemory.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2015 Fluiddynamics. All rights reserved.
//

import Foundation
import Tags

class TagMemory: TagsInterface {
  func getTagsByPrefix(prefix: String) -> [String] {
    let tags = Array(MemoryData.tags)
    return tags.filter {
      $0.hasPrefix(prefix)
    }
  }
  func getAllTags() -> Set<String> {
    return MemoryData.tags
  }
  func insertTag(tag: String) {
    MemoryData.tags.insert(tag)
  }
}
