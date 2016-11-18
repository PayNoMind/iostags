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
  @IBOutlet fileprivate weak var textInput: UITextView! {
    didSet {
      self.presentSuggestionView()
      textInput.layer.cornerRadius = 20.0
      textInput.delegate = self
    }
  }
  fileprivate lazy var datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    return datePicker
  }()
  fileprivate lazy var datePickerToolbar: UIToolbar = {
    let toolBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
    let toolbar = UIToolbar(frame: toolBarFrame)

    toolbar.items = ([.cancel(self), .flexibleSpace, .done(self)] as [BarButtonHelper]).map { $0.button }
    return toolbar
  }()
  fileprivate lazy var suggestionView: SuggestionView = SuggestionView()

  fileprivate var saveText = ""

  var suggestions: ((String, (([TagParser.TagContainer]) -> Void)) -> Void)?

  var text: String? {
    set {
      self.textInput.text = newValue
    }
    get {
      return self.textInput.text
    }
  }

  var textPass: ((String) -> Void)?

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    commonInit()
  }

  fileprivate func commonInit() {
    modalPresentationStyle = .custom
    transitioningDelegate = self
    view.layer.cornerRadius = 20.0
  }

  @objc
  func done(_ button: UIBarButtonItem) {
    print("done")
  }

  @objc
  func cancel(_ button: UIBarButtonItem) {
    presentSuggestionView()
    textInput.text = saveText
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    suggestionView.setSuggestion = { selection in
      if let command = selection.type, command.usesDatePicker {
        self.presentDatePicker()

        let date = self.datePicker.date
        self.textInput.text = FormatDate.format(date)
      }
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textInput.becomeFirstResponder()
  }

  fileprivate func presentSuggestionView() {
    let shouldReset = textInput.inputAccessoryView != nil

    textInput.inputView = nil

    textInput.inputAccessoryView = suggestionView

    resetInputViews(shouldReset)
  }

  fileprivate func resetInputViews(_ reset: Bool) {
    if reset {
      textInput.reloadInputViews()
    }
  }

  fileprivate func presentDatePicker() {
    saveText = textInput.text ?? ""

    textInput.inputView = self.datePicker
    textInput.inputAccessoryView = self.datePickerToolbar
    textInput.reloadInputViews()
  }

  func handleTap(_ sender: UITapGestureRecognizer) {
    dismiss(animated: true) {
      if let inputText = self.textInput.text {
        self.textPass?(inputText)
      }
    }
  }
}

extension TextEntryController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    if let tagText = textView.text {
      suggestions?(tagText) { suggestions in
        self.suggestionView.suggestions = suggestions
      }
    }
  }
}

extension TextEntryController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return InputPresentationController(presentedViewController: presented, presenting: presenting)
  }
}
