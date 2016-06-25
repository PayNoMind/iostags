//
//  SuggestionView.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

public class SuggestionView: UICollectionView {
  private lazy var suggestionDataSource: CollectionArrayDataSource<String, CompletionCell> = {
    let ds = CollectionArrayDataSource<String, CompletionCell>(anArray: [self.tags], withCellIdentifier: String(CompletionCell), andCustomizeClosure: self.setupSuggestionCell)
    return ds
  }()

  public var editingTextField: UITextField?
  public var tags: [String] = [] {
    didSet {
      self.reloadData()
    }
  }
  public var setSuggesion: (String -> Void)?

  convenience public init() {
    let _layout = UICollectionViewFlowLayout()
    _layout.scrollDirection = .Horizontal
    _layout.estimatedItemSize = CGSize(width: 100, height: 38)
    _layout.minimumInteritemSpacing = 10

    let width = UIScreen.mainScreen().bounds.width
    let frame = CGRect(x: 0, y: 0, width: width, height: 40)
    self.init(frame: frame, collectionViewLayout: _layout)

    delegate = self
    dataSource = suggestionDataSource
    registerNibWith(Title: String(CompletionCell), withBundle: NSBundle(forClass: self.dynamicType))
  }

  private func setupSuggestionCell(cell: CompletionCell, item: String, path: NSIndexPath) {
    cell.title = tags[path.row]
    cell.backgroundColor = UIColor.redColor()
  }
}

extension SuggestionView: UICollectionViewDelegate {
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CompletionCell, tf = editingTextField
      else { return }

    tf.text = cell.title
    setSuggesion?(cell.title)
  }
}
