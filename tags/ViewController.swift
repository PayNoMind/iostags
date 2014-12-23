//
//  ViewController.swift
//  tags
//
//  Created by Tom Clark on 2014-08-16.
//  Copyright (c) 2014 fluid-dynamics. All rights reserved.
//

import UIKit

private let FontSize: CGFloat = 14.0
private let CornerRadius: CGFloat = 5.0
private let BorderWidth: CGFloat = 0.5
private let BorderColor = UIColor.blackColor().CGColor
private let StartingWidth: CGFloat = 20.0

class tagCell: UICollectionViewCell {
  private var textField: UITextField!
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
    textField.frame = CGRect(origin: CGPointMake(10, 0), size: bounds.size)
  }
  
//  private func shrinkWrap(text: String) {
//    let stringSize : NSString = text
//    let size : CGSize = stringSize.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(FontSize)])
//    let rectHold : CGRect = bounds
//    self.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, size.width+10.0, bounds.height)
//  }
  
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
  @IBOutlet var tagView : TagSpace?
  @IBOutlet var tagView2: UICollectionView!
  private var tags = ["groceries","home","work","test","stuff","longstringthatislong"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tagView2.delegate = self
    tagView2.dataSource = self
    
    setupTagSpace()
  }
  
  private func setupTagSpace() {
    tagView?.addTags(tags)
    var test = TagSpace(frame: CGRectMake(0, 600.0, 320.0, 20.0))
    self.view.addSubview(test)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    var stringSize = ""
    if indexPath.row < tags.count {
      stringSize = tags[indexPath.row]
    }
    if let setCell = collectionView.cellForItemAtIndexPath(indexPath) as? tagCell {
      stringSize = setCell.textField.text
    }
    
    var size = CGSizeMake(StartingWidth, 20)
    if stringSize != "" {
      size = getStringSize(stringSize)
    }
    
    
    return CGSizeMake(size.width+20, 20)
  }
  
  private func getStringSize(string: String) -> CGSize {
    return string.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(FontSize)])
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tags.count+1
  }
  
  func textField(textField: TagInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if countElements(string) > 0 {
      let lastCharacter = string.substringFromIndex(advance(string.endIndex, -1))
      
      if lastCharacter == " " {
        tags.append("")
        tagView2.insertItemsAtIndexPaths([NSIndexPath(forRow: tags.count-1, inSection: 0)])
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
        tagView2.collectionViewLayout.invalidateLayout()
        width = resultFrame.size.width+12.0
      }
      textField.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, width, resultFrame.size.height)
      
//      if textField.frame.width < rectHold.width {
//        tagShrunk(textField)
//      }
//      checkTagSize(textField)
    }
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell: tagCell = collectionView.dequeueReusableCellWithReuseIdentifier("tagCell", forIndexPath: indexPath) as tagCell
    cell.backgroundColor = UIColor.redColor()
    cell.textField.addTarget(self, action:"tagTextChanged:", forControlEvents: UIControlEvents.EditingChanged)
    cell.textField.delegate = self
    
    cell.textField.text = ""
    if indexPath.row < tags.count {
      cell.textField.text = tags[indexPath.row]
    }
    
    return cell
  }


}

