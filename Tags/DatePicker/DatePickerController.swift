//
//  DatePickerController.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-26.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

class DatePickerController: UIViewController {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    modalPresentationStyle = .Custom
    transitioningDelegate = self
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    modalPresentationStyle = .Custom
    transitioningDelegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }
}

extension DatePickerController: UIViewControllerTransitioningDelegate {
  func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
    return DatePresentationController(presentedViewController: presented, presentingViewController: presenting)
  }
}

class DatePresentationController: UIPresentationController {
  lazy var dimmingView: UIView = {
    let view = UIView(frame: self.containerView!.bounds)
    view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
    view.alpha = 0.0
    return view
  }()

  override func presentationTransitionWillBegin() {
    guard let containerView = containerView,
      let presentedView = presentedView()
      else { return }

    // Add the dimming view and the presented view to the heirarchy
    dimmingView.frame = containerView.bounds
    containerView.addSubview(dimmingView)
    containerView.addSubview(presentedView)

    // Fade in the dimming view alongside the transition
    if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
      transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
        self.dimmingView.alpha = 1.0
        }, completion:nil)
    }
  }

  override func frameOfPresentedViewInContainerView() -> CGRect {
    var rect = self.containerView?.bounds
    rect?.size.height = 200
    rect?.origin.y = self.containerView!.bounds.midY - 200

    return rect ?? CGRect.zero
  }
}
