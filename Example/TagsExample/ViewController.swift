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
  @IBOutlet var collection: UICollectionView!
  private var collectionDelegate: TagCollectionViewDelegate!
//  private var 

  override func viewDidLoad() {
    super.viewDidLoad()
    collection.delegate =
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

