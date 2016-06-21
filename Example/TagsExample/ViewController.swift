//
//  ViewController.swift
//  TagsExample
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2015 Fluiddynamics. All rights reserved.
//

import UIKit
import Tags

class ViewController: UIViewController {
  @IBOutlet var collection: UICollectionView! {
    didSet {
      collection.registerNibWith(Title: String(TagCell), withBundle: NSBundle(identifier: "ca.Fluiddynamics.Tags")!)

      tagDelegate = TagDelegate(collectionView: self.collection)
      (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 60, height: 20)
      collection.delegate = tagDelegate
    }
  }

  private var tagDelegate: TagDelegate!
}
