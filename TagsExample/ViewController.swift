//
//  ViewController.swift
//  TagsExample
//
//  Created by Tom Clark on 2016-06-25.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit
import Tags

class ViewController: UIViewController {
  @IBOutlet var collection: UICollectionView! {
    didSet {
      collection.setupCollectionAsTagView(tagDelegate, withDataSource: self, andOwner: self)
    }
  }

  fileprivate lazy var tagDelegate: TagDelegate = {
    return TagDelegate(collectionView: self.collection, tags: ["CheeseBurger"])
  }()

  fileprivate var tags: Set = ["groceries", "home", "work", "stuff", "longstringthatislong", "day"]
}

extension ViewController: TagsDataSource {
  func getTagsByPrefix(_ prefix: String) -> [String] {
    return tags.filter {
      $0.hasPrefix(prefix)
    }
  }

  func getAllTags() -> Set<String> {
    return tags
  }

  func insertTag(_ tag: String) {
    tags.insert(tag)
  }
}
