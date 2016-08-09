//
//  TextEntryController.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-29.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

protocol TextEntryProtocol {
  func getSuggestions(_: [String]) -> Void
}

class TextEntryController: UIViewController {
  @IBOutlet private weak var textInput: UITextField! {
    didSet {
      textInput.inputAccessoryView = suggestionView
    }
  }
  private lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    return datePicker
  }()

  private lazy var suggestionView: SuggestionView = SuggestionView()

  var suggestions: ((String, ([TagParser.TagContainer] -> Void)) -> Void)?

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

  @objc
  func tagTextChanged(textField: UITextField) {
    if let tagText = textField.text {
      suggestions?(tagText) { suggestions in
        self.suggestionView.suggestions = suggestions
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    suggestionView.setSuggestion = { selection in
      if let command = selection.type where command.usesDatePicker {
        self.textInput.inputView = self.datePicker
        self.textInput.reloadInputViews()
      }
    }

    textInput.addTarget(self, action: #selector(tagTextChanged), forControlEvents: .EditingChanged)
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
