//
//  TextFieldDelegate.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-18.
//  Copyright © 2015 Fluiddynamics. All rights reserved.
//

import UIKit

class TagsCollectionTextFieldDelegate: UITextFieldDelegate {
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    if textField.text == "Add Tag" {
      textField.text = ""
    }
    currentTextField = textField
    textField.inputAccessoryView = completionView
    return true
  }
  func textFieldDidBeginEditing(textField: UITextField) {
    if let cellIndex = textField.superview as? UICollectionViewCell, temp = collectionView.indexPathForCell(cellIndex)  {
      delegate.currentIndex = temp.row
    }
  }
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if string.characters.count > 0 {
      let completeString = textField.text! + string
      let lastCharacter = string.substringFromIndex(string.endIndex.advancedBy(-1))

      //updateSuggestions(parser.parse(completeString))
      if lastCharacter == " " {
        var idx = delegate.currentIndex+1
        if delegate.currentIndex == delegate.tags.endIndex {
          idx = delegate.tags.endIndex
        }
        delegate.tags.insert("", atIndex: idx)
        let indexPath = NSIndexPath(forRow: idx, inSection: 0)
        collectionView.insertItemsAtIndexPaths([indexPath])

        UIView.animateWithDuration(0.2, animations: { () -> Void in
          self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: false)
          }, completion: { (complete) -> Void in
            if let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? TagCell {
              cell.textField.becomeFirstResponder()
            }
        })
        return false
      }
    }
    return true
  }
}