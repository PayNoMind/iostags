//
//  CollectionViewDataSource.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-17.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

open class CollectionArrayDataSource<T, U: UICollectionViewCell>: NSObject, UICollectionViewDataSource {
  public typealias CustomizeClosure = (U, T, IndexPath) -> Void

  fileprivate var dataArray: [[T]]
  fileprivate var cellIdentifier: String
  fileprivate var customizeCellClosure: CustomizeClosure

  var numberOfItemsClosure: ((_ section: Int) -> Int)?
  var cellIDClosure: ((IndexPath) -> String)?
  var supplementryID: (() -> String)?
  var customizeSupplementryViewClosure: ((UICollectionReusableView, IndexPath) -> Void)?

  public init(anArray dataArray: [[T]], withCellIdentifier cellIdentifier: String, andCustomizeClosure customizeCellClosure: @escaping CustomizeClosure) {
    self.dataArray = dataArray
    self.cellIdentifier = cellIdentifier
    self.customizeCellClosure = customizeCellClosure
    super.init()
  }

  func updateData(_ dataArray: [[T]]) {
    self.dataArray = dataArray
  }

  private func itemAtIndexPath(_ indexPath: IndexPath) -> T? {
    guard indexPath.section < dataArray.count && indexPath.row < dataArray[indexPath.section].count
      else { return nil }

    return dataArray[indexPath.section][indexPath.row]
  }

  open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataArray.count
  }

  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let number = numberOfItemsClosure
      else { return dataArray[section].count }
    return number(section)
  }

  open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let supID = supplementryID?() ?? ""
    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: supID, for: indexPath)
    customizeSupplementryViewClosure?(view, indexPath)
    return view
  }

  private func getCellId(_ indexPath: IndexPath) -> String {
    guard let cellID = cellIDClosure
      else { return cellIdentifier }
    return cellID(indexPath)
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellId(indexPath), for: indexPath)
    guard let item = itemAtIndexPath(indexPath),
      let newCell = cell as? U
      else { return cell }
    customizeCellClosure(newCell, item, indexPath)
    return cell
  }
}
