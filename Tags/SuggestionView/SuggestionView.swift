//
//  SuggestionView.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

private let StartingWidth = CGFloat(20.0)

public class SuggestionView: UICollectionView {
  private var parser: TagParser!
  public var editingTextField: UITextField?
//  public var tagDelegate: TagDelegate!

  convenience public init(data: TagsInterface) {
    let _layout = UICollectionViewFlowLayout()
    _layout.scrollDirection = .Horizontal
    _layout.estimatedItemSize = CGSize(width: 100, height: 38)
    _layout.minimumInteritemSpacing = 10

    let frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40)
    self.init(frame: frame, collectionViewLayout: _layout)

    self.parser = TagParser(tags: data)

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
    tagTextChanged(tf)
  }

  private func tagTextChanged(textField: UITextField) {
    guard let text = textField.text
      where !text.isEmpty && text != " "
      else { return }

//    let pos = textField.beginningOfDocument
//    guard let pos2 = textField.tokenizer.positionFromPosition(pos, toBoundary: .Line, inDirection: 0)
//      else { return }
//
//    let range = textField.textRangeFromPosition(pos, toPosition: pos2)!
//    let resultFrame = textField.firstRectForRange(range)
//    let rectHold = textField.frame
//    let width = resultFrame.size.width+12.0 > StartingWidth ? CGFloat(20.0) : resultFrame.size.width+12.0


//    collectionView.collectionViewLayout.invalidateLayout()


    //tagDelegate.getTagAtIndex(tagDelegate.currentIndex) = textField.text!
    //delegate.tags[delegate.currentIndex] = textField.text!
//    textField.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, width, resultFrame.size.height)
    //collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: delegate.currentIndex, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)
  }
}

extension SuggestionView: UICollectionViewDataSource {
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return parser.currentContainer.suggestedTypes.count
  }

  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(CompletionCell), forIndexPath: indexPath)
    if let cell = cell as? CompletionCell {
      cell.title = parser.currentContainer.suggestedTypes[indexPath.row]
      cell.backgroundColor = UIColor.redColor()
    }
    return cell
  }
}
