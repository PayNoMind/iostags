//
//  CellWidth.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-21.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

//extension UITextField {
//  func textWidth() -> CGFloat {
//    var width = CGFloat(20.0)
//
//    if self.text != "" {
//
//      if let pos = self.beginningOfDocument as? UITextPosition,
//        pos2 = self.tokenizer.positionFromPosition(pos, toBoundary: .Word, inDirection: 0),
//        range = self.textRangeFromPosition(pos, toPosition: pos2) {
//
//        let resultFrame : CGRect = self.firstRectForRange(range)
//        let rectHold : CGRect = self.frame
//
//        if resultFrame.size.width+12.0 > 20.0 {
//          width = resultFrame.size.width + 12.0
//        }
//      }
//
////      self.frame = CGRectMake(rectHold.origin.x, rectHold.origin.y, width, resultFrame.size.height)
//
////      if rectHold.origin.x + max(rectHold.size.width, resultFrame.size.width + 10.0) > tagSpaceWidth {
////        self.tagDelegate?.tagTooWide(self)
////      } else {
////        self.tagDelegate?.checkIntersection(self)
////      }
//
//    }
//
//    return width
//  }
//}

struct CellWidth {
  static func widthOf(Text text: String, withFont font: UIFont) -> CGFloat {
    return text.size(withAttributes: [NSAttributedStringKey.font: font]).width
  }
}
