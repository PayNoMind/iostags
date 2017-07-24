//
//  NSObject+ObjectName.swift
//  Tags
//
//  Created by Tom Clark on 2017-07-23.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import UIKit

extension UIView {
  class var nameString: String {
    return String(describing: self)
  }
}
