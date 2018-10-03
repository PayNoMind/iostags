//
//  CellWidth.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-21.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

struct CellWidth {
  static func widthOf(Text text: String, withFont font: UIFont) -> CGFloat {
    return text.size(withAttributes: [NSAttributedString.Key.font: font]).width
  }
}
