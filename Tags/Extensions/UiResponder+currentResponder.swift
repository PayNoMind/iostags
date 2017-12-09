//
//  UiResponder+currentResponder.swift
//  Tags
//
//  Created by Tom Clark on 2017-12-08.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

extension UIResponder {
  private weak static var _currentFirstResponder: UIResponder? = nil

  public static var first: UIResponder? {
    UIResponder._currentFirstResponder = nil
    UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
    return UIResponder._currentFirstResponder
  }

  @objc internal func findFirstResponder(sender: AnyObject) {
    UIResponder._currentFirstResponder = self
  }
}
