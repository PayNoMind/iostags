//
//  CollectionView.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-17.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

extension UICollectionView {
  public func registerNibWith(Title title: String, withBundle bundle: NSBundle?) {
    let nib = UINib(nibName: title, bundle: bundle)
    self.registerNib(nib, forCellWithReuseIdentifier: title)
  }
}
