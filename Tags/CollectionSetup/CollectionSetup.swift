//
//  CollectionSetup.swift
//  Tags
//
//  Created by Tom Clark on 2016-08-02.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

extension UICollectionView {
  public func setupCollectionAsTagView(_ tagDelegate: TagDelegate, withDataSource dataSource: TagsDataSource) {
    self.registerNibWithTitle(String(describing: TagCell.self), withBundle: Bundle.tagBundle)

    tagDelegate.tagDataSource = dataSource
    self.dataSource = tagDelegate.collectionDataSource

    (self.collectionViewLayout as? UICollectionViewFlowLayout)?.estimatedItemSize = CGSize(width: 60, height: 20)
    self.delegate = tagDelegate
  }
}
