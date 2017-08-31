//
//  String+IsCommand.swift
//  Tags
//
//  Created by Tom Clark on 2017-08-26.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import Foundation

extension String {
  var isCommand: Bool {
    let commandPrefix = ":"
    return self.hasPrefix(commandPrefix)
  }
}
