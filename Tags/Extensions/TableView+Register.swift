//
//  TableView+Register.swift
//  Tags
//
//  Created by Tom Clark on 2017-07-23.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import UIKit

extension UITableView {
  public func registerNibWithTitle(_ title: String, withBundle bundle: Bundle?) {
    let nib = UINib(nibName: title, bundle: bundle)
    self.register(nib, forCellReuseIdentifier: title)
  }
}
