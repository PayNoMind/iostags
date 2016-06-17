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
      collection.delegate = collectionDelegate
    }
  }
  private lazy var collectionDelegate: TagCollectionViewDelegate = {
    let viewDelegate = TagCollectionViewDelegate()
    return viewDelegate
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    

  }

}
