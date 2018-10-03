//
//  UIFont+textWidth.swift
//  Tags
//
//  Created by Tom Clark on 2018-10-03.
//  Copyright © 2018 Fluiddynamics. All rights reserved.
//

import Foundation

extension UIFont {
  func widthOfText(_ text: String) -> CGFloat {
      return text.size(withAttributes: [NSAttributedString.Key.font: self]).width
  }
}
