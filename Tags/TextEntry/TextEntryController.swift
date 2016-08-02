//
//  TextEntryController.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-29.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

class TextEntryController: UIViewController {
  @IBOutlet private weak var textInput: UITextField!

  var text: String? {
    didSet {
      self.textInput.text = text
    }
  }

  var textPass: (String -> Void)?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    commonInit()
  }

  private func commonInit() {
    modalPresentationStyle = .Custom
    transitioningDelegate = self
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    textInput.becomeFirstResponder()
  }

  func handleTap(sender: UITapGestureRecognizer) {
    dismissViewControllerAnimated(true) {
      if let inputText = self.textInput.text {
        self.textPass?(inputText)
      }
    }
  }
}

extension TextEntryController: UIViewControllerTransitioningDelegate {
  func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    return InputPresentationController(presentedViewController: presented, presentingViewController: presenting)
  }
}
