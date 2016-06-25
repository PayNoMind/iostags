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
      collection.registerNibWith(Title: String(TagCell), withBundle: NSBundle(identifier: "ca.Fluiddynamics.Tags")!)

      tagDelegate = TagDelegate(collectionView: self.collection)
      (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 60, height: 20)
      collection.delegate = tagDelegate
    }
  }

  private var tagDelegate: TagDelegate!


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}
