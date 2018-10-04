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
      collection.setupCollectionAsTagView(tagDelegate, withDataSource: self)
    }
  }
  @IBOutlet weak var tagList: UITextView!

  fileprivate lazy var tagDelegate: TagDelegate = {
    let delegate = TagDelegate(tags: ["CheeseBurger"])
    delegate.tagDataSource = self
    return delegate
  }()

  private var tags: Set = ["groceries", "CheeseBurger", "home", "work", "stuff", "longstringthatislong", "day"]

  override func viewDidAppear(_ animated: Bool) {
    tagList.text = tags.joined(separator: ",\n")

    print("\(tagDelegate.getTags())")
  }
}

extension ViewController: TagsDataSource {
  func insertTag(_ tag: Tag) {
    tags.insert(tag.value)
  }

  func deleteTag(_ tag: String) {
    tags.remove(tag)
  }

  func getTagsByPrefix(_ prefix: String) -> [String] {
    return tags.filter {
      $0.lowercased().hasPrefix(prefix)
    }
  }

  func insertTags(_ tags: Set<String>) {
    for tag in tags {
      self.tags.insert(tag)
    }
  }

  func getAllTags() -> Set<String> {
    return tags
  }

  func insertTag(_ tag: String) {
    tags.insert(tag)
  }
}
