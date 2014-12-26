//
//  ViewController.swift
//  tags
//
//  Created by Tom Clark on 2014-08-16.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var tagView2: UICollectionView!
  private var tags = ["groceries","home","work","test","stuff","longstringthatislong"]
  var tagDelegate: TagDelegate!
  var collectionDelegate: TagCollectionViewDelegate!
  var collectionDataSource: TagDataSource!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tagDelegate = TagDelegate(tags: tags)
    let sources = tagDelegate.setupDelegateAndDataSource(tagView2)
    collectionDelegate = sources.delegate
    collectionDataSource = sources.dataSource
    
    tagView2.delegate = collectionDelegate
    tagView2.dataSource = collectionDataSource
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

