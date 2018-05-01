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
  @IBOutlet weak var tagList: UITextView!

  fileprivate lazy var tagDelegate: TagDelegate = {
    return TagDelegate(collectionView: self.collection, tags: ["CheeseBurger"])
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

  func deleteTag(Tag tag: String) {
    tags.remove(tag)
  }

  func getTagsBy(Prefix prefix: String) -> [String] {
    return tags.filter {
      $0.lowercased().hasPrefix(prefix)
    }
  }

  func insert(Tags tags: Set<String>) {
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
