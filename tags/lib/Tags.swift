//
//  tag.swift
//  Priority
//
//  Created by Tom Clark on 2014-06-28.
//  Copyright (c) 2014 Fluiddynamics. All rights reserved.
//

import UIKit

extension Array {
  var last: T {
    return self[self.endIndex - 1]
  }
}

protocol TagDelegate {
  func tagTooWide(send:TagInput)
  func checkIntersection(send:TagInput)
}

let CORNER_RADIUS : CGFloat = 5.0
let LABEL_MARGIN_DEFAULT = 5.0
let BOTTOM_MARGIN_DEFAULT = 5.0
let HORIZONTAL_PADDING_DEFAULT = 7.0
let VERTICAL_PADDING_DEFAULT = 3.0
let BACKGROUND_COLOR = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
let TEXT_COLOR = UIColor.blackColor()
let TEXT_SHADOW_COLOR = UIColor.whiteColor()
let TEXT_SHADOW_OFFSET = CGSizeMake(0.0, 1.0)
let BORDER_COLOR = UIColor.blackColor().CGColor
let BORDER_WIDTH : CGFloat = 0.5
let DEFAULT_WIDTH : CGFloat = 50.0
let DEFAULT_HEIGHT : CGFloat = 17.0
let STARTING_WIDTH : CGFloat = 20.0
let FONT_SIZE : CGFloat = 14.0

class TagInput : UITextField, Equatable {
  var tagDelegate : TagDelegate?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "myTextDidChange:", name: "UITextFieldTextDidChangeNotification", object: self)
    self.layer.borderWidth = BORDER_WIDTH
    self.layer.borderColor = BORDER_COLOR
    self.layer.cornerRadius = CORNER_RADIUS
    self.layer.masksToBounds = true
    self.font = UIFont.systemFontOfSize(FONT_SIZE)
    self.returnKeyType = .Done
  }
  
  convenience init(position: CGPoint, string:String="") {
    NSLog("called %f", DEFAULT_WIDTH)
    self.init(frame:CGRectMake(position.x, position.y, DEFAULT_WIDTH, DEFAULT_HEIGHT))
    self.text = string
    //self.shrinkWrap()
  }
  
  func shrinkWrap() {
    let stringSize : NSString = self.text
    let size : CGSize = stringSize.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(FONT_SIZE)])
    let rectHold : CGRect = self.frame
    self.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, size.width+10.0, DEFAULT_HEIGHT)
  }
  
  func updatePosition(pos: CGPoint) {
    var frame : CGRect = self.frame
    frame.origin = pos
    self.frame = frame
  }
  
  func myTextDidChange(send: NSNotification) {
    if (send.object as UITextField).text != "" {
      let pos : UITextPosition = self.beginningOfDocument
      self.layer.backgroundColor = UIColor.redColor().CGColor
      let pos2 : UITextPosition = self.tokenizer.positionFromPosition(pos, toBoundary: .Word, inDirection: 0)
      let range : UITextRange = self.textRangeFromPosition(pos, toPosition: pos2)
      let resultFrame : CGRect = self.firstRectForRange(range)
      let rectHold : CGRect = self.frame
      
      let tagSpaceWidth : CGFloat = self.superview!.frame.size.width
      
      var width : CGFloat = 20.0
      if resultFrame.size.width+12.0 > STARTING_WIDTH {
        width = resultFrame.size.width+12.0
      }
      self.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, width, resultFrame.size.height)
      
      if rectHold.origin.x + max(rectHold.size.width, resultFrame.size.width + 10.0) > tagSpaceWidth {
        self.tagDelegate?.tagTooWide(self)
      } else {
        self.tagDelegate?.checkIntersection(self)
      }
    }
  }
  
  override func textRectForBounds(bounds: CGRect) -> CGRect {
    let inset : CGRect = CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 10, bounds.size.height)
    return inset
  }
  
  override func editingRectForBounds(bounds: CGRect) -> CGRect {
    let inset : CGRect = CGRectMake(bounds.origin.x + 5, bounds.origin.y, bounds.size.width - 10, bounds.size.height)
    return inset
  }
}

func == (lhs: TagInput, rhs: TagInput) -> Bool {
  return lhs.text == rhs.text
}

/*
  Tag Space Class
*/
class TagSpace : UIScrollView, UITextFieldDelegate, TagDelegate {
  var tagArray = [TagInput]()
  var activeField = UITextField()
  //var plateDelegate : movePlates?
  var contentSave : CGFloat = 0
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.contentSize = CGSizeMake(self.frame.width, self.frame.height)
    self.scrollEnabled = true
    contentSave = self.frame.width
    self.addNewTag(false)
  }
  
  //for testing
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  func addTags(tags:[String]) {
    for tag in tags {
      self.addNewTag(false, string: tag)
    }
  }
  
  func getTags () -> [TagInput] {
    return tagArray
  }
  
  func getTagCardinality () -> Int {
    return tagArray.count
  }
  
  func checkIntersection(sender:TagInput) {
    let typingTag = find(tagArray, sender)
    
    if typingTag==tagArray.count-1 {
      return
    }
    
    let nextTag : TagInput = tagArray[(typingTag!+1)]
    var tempFrame : CGRect = nextTag.frame
    tempFrame.origin.x -= 1.0
    
    if CGRectIntersectsRect(sender.frame, tempFrame) {
      NSLog("Intersect!!")
      self.slideTags(typingTag!)
    }
  }
  
  func slideTags(indexStart: Int) {
    NSLog("index is %ld %lu",indexStart,(tagArray.count-indexStart-1))
    let indexes = NSIndexSet(indexesInRange: NSMakeRange(indexStart+1, tagArray.count-indexStart-1))
    
    for idx in indexStart+1...(tagArray.count-1) {
      var object : TagInput = tagArray[idx]
      let prevTag : TagInput = tagArray[idx-1]
      let prevWidth : CGFloat = prevTag.frame.origin.x + prevTag.frame.size.width
      var temp : CGRect = object.frame
      temp.origin.x = prevWidth + 5.0
      object.frame = temp
      
      if (object.frame.origin.x+object.frame.size.width) >= 300.0 {
        self.tagTooWide(object)
      }
    }
  }
  
  func checkHeight(field:TagInput) -> Bool {
    let lastHeight : CGFloat = field.frame.origin.y
    if lastHeight >= self.frame.size.height {
      return true
    }
    return false
  }
  
  func tagTooWide(lastObj:TagInput) {
    let lastHeight : CGFloat = lastObj.frame.size.height
    let lastY : CGFloat = lastObj.frame.origin.y
    let nextPos : CGFloat = lastHeight+lastY+4.0
    
    NSLog("Tag too wide %@",nextPos)
    //lastObj.updatePosition(CGPointMake(0.0, nextPos))
    if self.checkHeight(lastObj) || true {
      self.contentSize = CGSizeMake(self.frame.width + lastObj.frame.width, self.frame.height)
      NSLog("content size %@", self.contentSize.width)
//      var frame = self.frame
//      frame.size.height += lastHeight+4.0
//      self.frame = frame
    }
    //self.plateDelegate?.tagSpaceExpanding()
  }
  
  func resetTagSpace() {
    for tag in tagArray {
      tag.removeFromSuperview()
    }
    tagArray.removeAll(keepCapacity: false)
    self.addNewTag(false)
  }
  
  func addNewTag(becomeFirstResponder: Bool, string:String="") {
    var lastY : CGFloat = 0.0
    var nextPos : CGFloat = 0.0
    
    if tagArray.count > 0 {
      //Check if last tag is empty
      if countElements(tagArray.last.text) == 0 {
        tagArray.last.text = string
        tagArray.last.shrinkWrap()
        return
      } else {
        let lastWidth = tagArray.last.frame.size.width
        let lastX = tagArray.last.frame.origin.x
        lastY = tagArray.last.frame.origin.y
        nextPos = lastX+lastWidth+4.0
      }
    }
    
    tagArray.append(TagInput(position: CGPointMake(nextPos, lastY), string: string))
    NSLog("nextpos = %f",self.frame.size.width)
    tagArray.last.shrinkWrap()
    tagArray.last.delegate = self
    tagArray.last.tagDelegate = self
    
    if nextPos+STARTING_WIDTH >= self.frame.width {
      self.tagTooWide(tagArray.last)
    }
    self.addSubview(tagArray.last)
    
    if becomeFirstResponder {
      tagArray.last.becomeFirstResponder()
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField.text >= "" {//If tag has text
      self.addNewTag(false)
    } else { //If tag is empty
      var fieldFrame : CGRect = textField.frame
      fieldFrame.size.width = DEFAULT_WIDTH
      textField.frame = fieldFrame
    }
    textField.resignFirstResponder()
    return true
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if countElements(string) > 0 {
      let lastCharacter = string.substringFromIndex(advance(string.endIndex, -1))
      
      if lastCharacter == " " {
        self.addNewTag(true)
        return false
      }
    }
    return true
  }
  
  func textFieldDidBeginEditing(textField: UITextField!) {
    activeField = textField
    
    if textField.text == "" {
      var tag = textField.frame
      tag.size.width = STARTING_WIDTH
      textField.frame = tag
    }
  }

}
