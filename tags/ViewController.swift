//
//  ViewController.swift
//  tags
//
//  Created by Tom Clark on 2014-08-16.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet var tagView : TagSpace?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tagView?.addTags(["groceries","home","work","test","stuff"])
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

