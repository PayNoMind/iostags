//
//  TagMemory.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2015 Fluiddynamics. All rights reserved.
//

import Foundation
import Tags

class TagMemory: TagsDataSource {
  func getTagsBy(Prefix prefix: String) -> [String] {
    let tags = Array(MemoryData.tags)
    return tags.filter {
      $0.hasPrefix(prefix)
    }
  }

  func getAllTags() -> Set<String> {
    return MemoryData.tags
  }

  func insert(Tag tag: String) {
    MemoryData.tags.insert(tag)
  }

  func insert(Tags tags: Set<String>) {
    for tag in tags {
      self.insert(Tag: tag)
    }
  }
}
