//
//  InputPresentationController.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-29.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import Foundation

class InputPresentationController: UIPresentationController {
  private lazy var dimmingView: UIView = {
    let view = UIView(frame: self.containerView?.bounds ?? CGRect.zero)
    view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
    view.alpha = 0.0

    let gesture = UITapGestureRecognizer(target: self.presentedViewController, action: #selector(DatePickerController.handleTap))

    view.addGestureRecognizer(gesture)

    return view
  }()

  override func presentationTransitionWillBegin() {
    guard let containerView = containerView,
      presentedView = presentedView()
      else { return }

    // Add the dimming view and the presented view to the heirarchy
    dimmingView.frame = containerView.bounds
    containerView.addSubview(dimmingView)
    containerView.addSubview(presentedView)

    // Fade in the dimming view alongside the transition
    if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
      transitionCoordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
        self.dimmingView.alpha = 1.0
      }, completion:nil)
    }
  }

  override func frameOfPresentedViewInContainerView() -> CGRect {
    let rectHeight = presentedViewController is DatePickerController ? CGFloat(200.0) : CGFloat(100)

    if var rect = self.containerView?.bounds {
      rect.size.height = rectHeight
      rect.origin.y = (self.containerView?.bounds ?? CGRect.zero).midY - rectHeight
      return rect
    }
    
    return CGRect.zero
  }
}
