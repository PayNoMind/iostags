//
//  SuggestionView.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

public class SuggestionView: UICollectionView {

  private let startingWidth = CGFloat(20.0)

  public var editingTextField: UITextField?
  public var elementPassing: (Void -> [String])?
  public var getSuggestions: (String -> Void)?

  convenience public init() {
    let _layout = UICollectionViewFlowLayout()
    _layout.scrollDirection = .Horizontal
    _layout.estimatedItemSize = CGSize(width: 100, height: 38)
    _layout.minimumInteritemSpacing = 10

    let width = UIScreen.mainScreen().bounds.width
    let frame = CGRect(x: 0, y: 0, width: width, height: 40)
    self.init(frame: frame, collectionViewLayout: _layout)

    delegate = self
    dataSource = self
    registerNibWith(Title: String(CompletionCell), withBundle: NSBundle(forClass: self.dynamicType))
  }
}

extension SuggestionView: UICollectionViewDelegate {
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CompletionCell, tf = editingTextField
      else { return }

    tf.text = cell.title
    getSuggestions?(cell.title)
  }
}

extension SuggestionView: UICollectionViewDataSource {
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return elementPassing?().count ?? 0
  }

  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(CompletionCell), forIndexPath: indexPath)
    if let cell = cell as? CompletionCell, elements = elementPassing {
      cell.title = elements()[indexPath.row]
      cell.backgroundColor = UIColor.redColor()
    }
    return cell
  }
}
