//The MIT License (MIT)
//
//Copyright (c) 2014 Tom Clark
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
import UIKit

func == (lhs: TagInput, rhs: TagInput) -> Bool {
  return lhs.text == rhs.text
}

private let CORNER_RADIUS : CGFloat = 5.0
private let LABEL_MARGIN_DEFAULT : CGFloat = 5.0
private let BOTTOM_MARGIN_DEFAULT : CGFloat = 5.0
private let HORIZONTAL_PADDING_DEFAULT : CGFloat = 7.0
private let VERTICAL_PADDING_DEFAULT : CGFloat = 3.0
private let BACKGROUND_COLOR = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
private let TEXT_COLOR = UIColor.blackColor()
private let TEXT_SHADOW_COLOR = UIColor.whiteColor()
private let TEXT_SHADOW_OFFSET = CGSizeMake(0.0, 1.0)
private let BORDER_COLOR = UIColor.blackColor().CGColor
private let BORDER_WIDTH: CGFloat = 0.5
private let DEFAULT_WIDTH: CGFloat = 50.0
private let DEFAULT_HEIGHT: CGFloat = 17.0
private let STARTING_WIDTH: CGFloat = 20.0
private let FONT_SIZE: CGFloat = 14.0

/*
  TagInput Class
*/
class TagInput : UITextField, Equatable {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.textColor = TEXT_COLOR
    self.layer.masksToBounds = true
    self.layer.borderWidth = BORDER_WIDTH
    self.layer.borderColor = BORDER_COLOR
    self.layer.cornerRadius = CORNER_RADIUS
    self.layer.backgroundColor = BACKGROUND_COLOR.CGColor
    self.font = UIFont.systemFontOfSize(FONT_SIZE)
    self.returnKeyType = .Done
  }
  
  convenience init(position: CGPoint, string:String="") {
    self.init(frame:CGRectMake(position.x, position.y, DEFAULT_WIDTH, DEFAULT_HEIGHT))
    self.text = string
  }
  
  func shrinkWrap() {
    let stringSize : NSString = self.text
    let size : CGSize = stringSize.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(FONT_SIZE)])
    let rectHold : CGRect = self.frame
    self.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, size.width+10.0, DEFAULT_HEIGHT)
  }
  
  //Functions for margins over uitextfields
  //Used to center the text
  override func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectMake(bounds.origin.x + LABEL_MARGIN_DEFAULT, bounds.origin.y, bounds.size.width - 10, bounds.size.height)
  }
  
  override func editingRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectMake(bounds.origin.x + LABEL_MARGIN_DEFAULT, bounds.origin.y, bounds.size.width - 10, bounds.size.height)
  }
}

/*
  Tag Space Class
*/
private let HORIZONTAL_SCROLL = true
class TagSpace : UIScrollView, UITextFieldDelegate {
  var tagArray = [TagInput]()
  var activeField = UITextField()
  var totalWidth : CGFloat = 0.0
  var actualWidth : CGFloat = 0
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.scrollEnabled = true
    NSLog("yo %@ 2:%@",self.frame.width-(self.frame.width-320.0), UIScreen.mainScreen().bounds.width)

    if HORIZONTAL_SCROLL {
      actualWidth = self.frame.width-(self.frame.width-UIScreen.mainScreen().bounds.width)
      totalWidth = actualWidth
      self.contentSize = CGSizeMake(actualWidth, 0.0)
    } else {
      actualWidth = self.frame.width-(self.frame.width-UIScreen.mainScreen().bounds.width)
      self.contentSize = CGSizeMake(actualWidth, 0.0)
    }
    self.addNewTag(false)
  }
  
  //for testing
  override init(frame: CGRect) {
    super.init(frame: frame)
    NSLog("Frame Called")
    self.addNewTag(false, string:"cheeseburger")
  }
  
  func addTags(tags:[String]) {
    for tag in tags {
      self.addNewTag(false, string: tag)
    }
    self.addNewTag(false)
  }
  
  func getTags () -> [TagInput] {
    return tagArray
  }
  
  func getTagCardinality () -> Int {
    return tagArray.count
  }
  
  func tagShrunk(sender:TagInput) {
    let typingTag = find(tagArray, sender)
    self.slideTags(typingTag!)
  }
  
  func centerTag(currentTag:TagInput) {
    if currentTag.frame.width + currentTag.frame.origin.x > self.frame.width/2.0 {
      self.scrollRectToVisible(currentTag.frame, animated: true)
    }
  }

  //Handle any logic that deals with changing the size of content area
  func checkTagSize(currentTag:TagInput) {
    let tagIndex = find(tagArray, currentTag)
    let tagFrame = currentTag.frame
    
    self.centerTag(currentTag)
    
    if tagFrame.origin.x + max(tagFrame.size.width, tagFrame.size.width + 10.0) > self.contentSize.width {
      self.tagTooWide(currentTag)
    } else {
      self.checkIntersection(currentTag)
    }
  }

  func checkIntersection(sender:TagInput) {
    let typingTagIdx = find(tagArray, sender)
    let typingTag = tagArray[typingTagIdx!]
    
    if typingTag==tagArray.last {
      return
    }
    
    let nextTag : TagInput = tagArray[(typingTagIdx!+1)]
    var tempFrame : CGRect = nextTag.frame
    tempFrame.origin.x -= 1.0
    
    if CGRectIntersectsRect(sender.frame, tempFrame) {
      NSLog("Intersect!!")
      self.slideTags(typingTagIdx!)
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
      
      checkTagSize(object)
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
    let lastWidth : CGFloat = lastObj.frame.size.width
    let lastY : CGFloat = lastObj.frame.origin.y
    let nextPos : CGFloat = lastHeight+lastY+4.0
    
    NSLog("Tag too wide %@",self.frame.width + lastObj.frame.width)
    //lastObj.updatePosition(CGPointMake(0.0, nextPos))
    if self.checkHeight(lastObj) && !HORIZONTAL_SCROLL {
      self.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width + lastObj.frame.width, self.frame.height)
      var frame = self.frame
      frame.size.height += lastHeight+4.0
      self.frame = frame
    } else {
      totalWidth += nextPos + lastWidth
      self.contentSize = CGSizeMake(totalWidth, self.frame.height)
      println("Expand width content size \(self.contentSize.width) and total width \(totalWidth)")
    }
  }
  
  func resetTagSpace() {
    for tag in tagArray {
      tag.removeFromSuperview()
    }
    tagArray.removeAll(keepCapacity: false)
    self.addNewTag(false)
  }

  func tagTextChanged(textField: TagInput) {
    if textField.text != "" {
      let pos : UITextPosition = textField.beginningOfDocument
      let pos2 : UITextPosition = textField.tokenizer.positionFromPosition(pos, toBoundary: .Word, inDirection: 0)!
      let range : UITextRange = textField.textRangeFromPosition(pos, toPosition: pos2)
      let resultFrame : CGRect = textField.firstRectForRange(range)

      let rectHold : CGRect = textField.frame
      
      var width : CGFloat = 20.0
      if resultFrame.size.width+12.0 > STARTING_WIDTH {
        width = resultFrame.size.width+12.0
      }
      textField.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, width, resultFrame.size.height)

      if textField.frame.width < rectHold.width {
        self.tagShrunk(textField)
      }
      self.checkTagSize(textField)
    }
  }
  
  func addNewTag(becomeFirstResponder: Bool, string:String="") {
    var lastY : CGFloat = 0.0
    var nextPos : CGFloat = 0.0
    
    if tagArray.count > 0 {
      //Check if last tag is empty
      if countElements(tagArray.last!.text) == 0 {
        tagArray.last!.text = string
        tagArray.last!.shrinkWrap()
        return
      } else {
        let lastWidth = tagArray.last!.frame.size.width
        let lastX = tagArray.last!.frame.origin.x
        lastY = tagArray.last!.frame.origin.y
        nextPos = lastX+lastWidth+4.0
      }
    }
    tagArray.append(TagInput(position: CGPointMake(nextPos, lastY), string: string))
    if string != "" {
      tagArray.last!.shrinkWrap()
    }
    tagArray.last?.delegate = self
    tagArray.last?.addTarget(self, action:"tagTextChanged:", forControlEvents: UIControlEvents.EditingChanged)

    NSLog("nextpos = 1:%@ 2:%@ 3:%@ 4:%@", self.frame.width, nextPos+tagArray.last!.frame.width, nextPos, tagArray.last!.frame.width)
    checkTagSize(tagArray.last!)
    self.addSubview(tagArray.last!)
    
    if becomeFirstResponder {
      tagArray.last?.becomeFirstResponder()
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
  
  func textField(textField: TagInput, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
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
