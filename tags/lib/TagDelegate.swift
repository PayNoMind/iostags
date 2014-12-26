//
//  TagDelegate.swift
//  Tags
//
//  Created by Tom Clark on 2014-12-26.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

import UIKit

private let FontSize: CGFloat = 14.0
private let CornerRadius: CGFloat = 5.0
private let BorderWidth: CGFloat = 0.5
private let BorderColor = UIColor.blackColor().CGColor
private let StartingWidth: CGFloat = 20.0
private let Padding: CGFloat = 5.0

class tagCell: UICollectionViewCell {
  var textField: UITextField!
  var text: String = ""
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    var test = bounds
    textField = UITextField(frame: bounds)
    textField.font = UIFont.systemFontOfSize(FontSize)
    textField.text = text
    addSubview(textField)
    layer.cornerRadius = CornerRadius
    layer.borderWidth = BorderWidth
    layer.borderColor = BorderColor
  }
  
  override func layoutSubviews() {
    var size = bounds.size
    size.width -= Padding
    textField.frame = CGRect(origin: CGPointMake(Padding, 0), size: size)
  }
}

protocol TagProtocol {
  func getTags() -> [String]
}

class TagDelegate: TagProtocol {
  private var tags: [String] = [String]()
  
  convenience init(tags: [String]) {
    self.init()
    self.tags = tags
  }

  func setupDelegateAndDataSource(collectionView: UICollectionView) -> (delegate: TagCollectionViewDelegate, dataSource: TagDataSource) {
    let tagDelegate = TagCollectionViewDelegate()
    tagDelegate.delegate = self
    let tagDatasource = TagDataSource(collectionView: collectionView)
    tagDatasource.delegate = self
    return (tagDelegate,tagDatasource)
  }
  
  func getTags() -> [String] {
    return tags
  }
}

class TagCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
  var delegate: TagDelegate!
  
  private func getStringSize(string: String) -> CGSize {
    return string.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(FontSize)])
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    var stringSize = ""
    if indexPath.row < delegate.getTags().count {
      stringSize = delegate.getTags()[indexPath.row]
    }
    if let setCell = collectionView.cellForItemAtIndexPath(indexPath) as? tagCell {
      stringSize = setCell.textField.text
    }
    
    var size = CGSizeMake(StartingWidth, 20)
    if stringSize != "" {
      size = getStringSize(stringSize)
    }
    
    return CGSizeMake(size.width + 10, 20)
  }

}

class TagDataSource: NSObject, UICollectionViewDataSource, UITextFieldDelegate {
  private var delegate: TagDelegate!
  private var collectionView: UICollectionView!
  
  convenience init(collectionView: UICollectionView) {
    self.init()
    self.collectionView = collectionView
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return delegate.tags.count+1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell: tagCell = collectionView.dequeueReusableCellWithReuseIdentifier("tagCell", forIndexPath: indexPath) as tagCell
    cell.backgroundColor = UIColor.redColor()
    cell.textField.addTarget(self, action:"tagTextChanged:", forControlEvents: UIControlEvents.EditingChanged)
    cell.textField.delegate = self
    
    cell.textField.text = ""
    if indexPath.row < delegate.getTags().count {
      cell.textField.text = delegate.getTags()[indexPath.row]
    }
    
    return cell
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if countElements(string) > 0 {
      let lastCharacter = string.substringFromIndex(advance(string.endIndex, -1))
      
      if lastCharacter == " " {
        delegate.tags.append("")
        collectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: delegate.getTags().count, inSection: 0)])
        return false
      }
    }
    return true
  }
  
  func tagTextChanged(textField: UITextField) {
    if textField.text != "" {
      let pos : UITextPosition = textField.beginningOfDocument
      let pos2 : UITextPosition = textField.tokenizer.positionFromPosition(pos, toBoundary: .Word, inDirection: 0)!
      let range : UITextRange = textField.textRangeFromPosition(pos, toPosition: pos2)
      let resultFrame : CGRect = textField.firstRectForRange(range)
      
      let rectHold : CGRect = textField.frame
      
      var width : CGFloat = 20.0
      if resultFrame.size.width+12.0 > StartingWidth {
        collectionView.collectionViewLayout.invalidateLayout()
        width = resultFrame.size.width+12.0
      }
      textField.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, width, resultFrame.size.height)
      
      //      if textField.frame.width < rectHold.width {
      //        tagShrunk(textField)
      //      }
      //      checkTagSize(textField)
    }
  }
}
