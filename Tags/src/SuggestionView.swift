//
//  SuggestionView.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2015 Fluiddynamics. All rights reserved.
//

import UIKit

private class CompletionCell: UICollectionViewCell {
  @IBOutlet weak var label: UILabel!
}

private let StartingWidth = CGFloat(20.0)

public class SuggestionView: UICollectionView {
  private var parser: TagParser!
  public var editingTextField: UITextField?
  public var tagDelegate: TagDelegate!
  
  convenience init(data: TagsInterface) {
    let _layout = UICollectionViewFlowLayout()
    _layout.scrollDirection = .Horizontal
    _layout.estimatedItemSize = CGSize(width: 100, height: 38)
    _layout.minimumInteritemSpacing = 10

    self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 40), collectionViewLayout: _layout)

    self.parser = TagParser(tags: data)
    delegate = self
    dataSource = self
    registerNib(UINib(nibName: "CompletionCell", bundle: nil), forCellWithReuseIdentifier: "completionCell")
  }
}

extension SuggestionView: UICollectionViewDelegate {
  public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CompletionCell, tf = editingTextField
      else { return }
    tf.text = ":\(cell.label.text!)"
    tagTextChanged(tf)
  }
  private func tagTextChanged(textField: UITextField) {
    guard !textField.text!.isEmpty && textField.text != " " else {
      return
    }

    let pos = textField.beginningOfDocument
    guard let pos2 = textField.tokenizer.positionFromPosition(pos, toBoundary: .Line, inDirection: 0)
      else { return }

    let range = textField.textRangeFromPosition(pos, toPosition: pos2)!
    let resultFrame = textField.firstRectForRange(range)
    let rectHold = textField.frame
    let width = resultFrame.size.width+12.0 > StartingWidth ? CGFloat(20.0) : resultFrame.size.width+12.0


//    collectionView.collectionViewLayout.invalidateLayout()


    //tagDelegate.getTagAtIndex(tagDelegate.currentIndex) = textField.text!
    //delegate.tags[delegate.currentIndex] = textField.text!
    textField.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, width, resultFrame.size.height)
    //collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: delegate.currentIndex, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: true)


  }
}

extension SuggestionView: UICollectionViewDataSource {
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return parser.currentContainer.suggestedTypes.count
  }
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("completionCell", forIndexPath: indexPath)
    if let cell = cell as? CompletionCell {
      cell.label.text = parser.currentContainer.suggestedTypes[indexPath.row]
      cell.backgroundColor = UIColor.redColor()
    }
    return cell
  }
}
