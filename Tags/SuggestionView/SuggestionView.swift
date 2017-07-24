//
//  SuggestionView.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

open class SuggestionView: UICollectionView {
  fileprivate lazy var suggestionDataSource: CollectionArrayDataSource<TagContainer, CompletionCell> = {
    return CollectionArrayDataSource<TagParser.TagContainer, CompletionCell>(anArray: [self.suggestions], withCellIdentifier: String(describing: CompletionCell.self), andCustomizeClosure: self.setupSuggestionCell)
  }()

  open var suggestions: [TagContainer] = [] {
    didSet {
      suggestionDataSource.updateData([suggestions])
      self.reloadData()
    }
  }
  open var setSuggestion: ((TagContainer) -> Void)?

  convenience public init() {
    let _layout = UICollectionViewFlowLayout()
    _layout.scrollDirection = .horizontal
    _layout.estimatedItemSize = CGSize(width: 100, height: 38)
    _layout.minimumInteritemSpacing = 10

    let width = UIScreen.main.bounds.width
    let frame = CGRect(x: 0, y: 0, width: width, height: 40)
    self.init(frame: frame, collectionViewLayout: _layout)

    delegate = self
    dataSource = suggestionDataSource
    registerNibWith(Title: String(describing: CompletionCell.self), withBundle: Bundle(for: type(of: self)))
  }

  fileprivate func setupSuggestionCell(_ cell: CompletionCell, item: TagContainer, path: IndexPath) {
    cell.title = suggestions[path.row].title
    cell.tagContainer = item
    cell.backgroundColor = UIColor.red
  }
}

extension SuggestionView: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? CompletionCell
      else { return }
    setSuggestion?(cell.tagContainer)
  }
}
