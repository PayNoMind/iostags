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
  func insertTag(_ tag: Tag) {
     MemoryData.tags.insert(tag.value)
  }

  func deleteTag(_ tag: String) {
    
  }

  func getTagsByPrefix(_ prefix: String) -> [String] {
    let tags = Array(MemoryData.tags)
    return tags.filter {
      $0.hasPrefix(prefix)
    }
  }

  func getAllTags() -> Set<String> {
    return MemoryData.tags
  }

  func insertTag(_ tag: String) {
    MemoryData.tags.insert(tag)
  }

  func insertTags(_ tags: Set<String>) {
    for tag in tags {
      self.insertTag(tag)
    }
  }
}
