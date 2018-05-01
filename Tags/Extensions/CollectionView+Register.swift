//
//  CollectionView.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-17.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

extension UICollectionView {
  public func registerNibWithTitle(_ title: String, withBundle bundle: Bundle?) {
    let nib = UINib(nibName: title, bundle: bundle)
    self.register(nib, forCellWithReuseIdentifier: title)
  }
}
