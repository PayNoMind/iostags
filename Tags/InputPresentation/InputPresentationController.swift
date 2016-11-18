//
//  InputPresentationController.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-29.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

class InputPresentationController: UIPresentationController {
  override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
    super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private var keyboardHeight: CGFloat = 0.0 {
    didSet {
      var currentFrame = presentedViewController.view.frame
      currentFrame.size.height = containerView!.bounds.height - keyboardHeight - 30
      presentedViewController.view.frame = currentFrame
    }
  }

  func keyboardWillShow(notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      self.keyboardHeight = keyboardSize.height
    }
  }

  fileprivate lazy var dimmingView: UIView = {
    let view = UIView(frame: self.containerView?.bounds ?? CGRect.zero)
    view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
    view.alpha = 0.0

    let gesture = UITapGestureRecognizer(target: self.presentedViewController, action: #selector(TextEntryController.handleTap))
    view.addGestureRecognizer(gesture)
    return view
  }()

  override func presentationTransitionWillBegin() {
    guard let containerView = containerView
      else { return }

    // Add the dimming view and the presented view to the heirarchy
    dimmingView.frame = containerView.bounds
    containerView.addSubview(dimmingView)

    // Fade in the dimming view alongside the transition
    if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
      transitionCoordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext?) -> Void in
        self.dimmingView.alpha = 1.0
      }, completion:nil)
    }
  }

//  override var frameOfPresentedViewInContainerView: CGRect {
//    let rectHeight = CGFloat(100)
//
//    var rect = self.containerView?.bounds ?? CGRect.zero
//    rect.size.height = rectHeight
//    rect.origin.y = rect.minY + 20
//
//    return rect
//  }
}
