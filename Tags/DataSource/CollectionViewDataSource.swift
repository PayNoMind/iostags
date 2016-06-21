//
//  CollectionViewDataSource.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-17.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

public class CollectionArrayDataSource<T, U: UICollectionViewCell>: NSObject, UICollectionViewDataSource {
  public typealias CustomizeClosure = (U, T, NSIndexPath) -> Void

  private var dataArray: [[T]]
  private var cellIdentifier: String
  private var customizeCellClosure: CustomizeClosure

  var numberOfItemsClosure: ((section: Int) -> Int)?
  var cellIDClosure: (NSIndexPath -> String)?
  var supplementryID: (Void -> String)?
  var customizeSupplementryViewClosure: ((UICollectionReusableView, NSIndexPath) -> ())?

  public init(anArray dataArray: [[T]], withCellIdentifier cellIdentifier: String, andCustomizeClosure customizeCellClosure: CustomizeClosure) {
    self.dataArray = dataArray
    self.cellIdentifier = cellIdentifier
    self.customizeCellClosure = customizeCellClosure
    super.init()
  }

  func updateData(dataArray: [[T]]) {
    self.dataArray = dataArray
  }

  private func itemAtIndexPath(indexPath: NSIndexPath) -> T? {
    guard indexPath.section < dataArray.count && indexPath.row < dataArray[indexPath.section].count
      else { return nil }

    return dataArray[indexPath.section][indexPath.row]
  }

  public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return dataArray.count
  }

  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let number = numberOfItemsClosure
      else { return dataArray[section].count }
    return number(section: section)
  }

  public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
    let id = supplementryID?() ?? ""
    let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: id, forIndexPath: indexPath)
    customizeSupplementryViewClosure?(view, indexPath)
    return view
  }

  private func getCellId(indexPath: NSIndexPath) -> String {
    guard let id = cellIDClosure
      else { return cellIdentifier }
    return id(indexPath)
  }

  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(getCellId(indexPath), forIndexPath: indexPath)
    guard let item = itemAtIndexPath(indexPath),
      newCell = cell as? U
      else { return cell }
    customizeCellClosure(newCell, item, indexPath)
    return cell
  }
}
