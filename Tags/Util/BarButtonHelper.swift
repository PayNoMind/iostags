//
//  Barbutton.swift
//  Tags
//
//  Created by Tom Clark on 2016-08-21.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

enum BarButtonHelper {
  case cancel(UIViewController)
  case done(UIViewController)
  case flexibleSpace

  var button: UIBarButtonItem {
    switch self {
    case .cancel(let target):
      return UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: #selector(TextEntryController.cancel))
    case .done(let target):
      return UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(TextEntryController.done))
    case .flexibleSpace:
      return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
  }
}
