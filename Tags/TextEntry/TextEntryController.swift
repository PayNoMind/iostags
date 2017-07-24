//
//  TextEntryController.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-29.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

@objc protocol TextEntryProtocol {
  func getSuggestions(_: [String])
}

class TextEntryController: UIViewController {
  @IBOutlet private weak var tagTable: UITableView! {
    didSet {
      self.tagTable.registerNibWith(Title: TagTitleCell.nameString, withBundle: Bundle.tagBundle)
      self.tagTable.dataSource = self.tableDataSource
    }
  }
  private lazy var tableDataSource: TableArrayDataSource<String> = {
    let temp = TableArrayDataSource<String>(anArray: [], withCellIdentifier: TagTitleCell.nameString, andCustomizeClosure: self.setupCell)
    return temp
  }()

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

  fileprivate var currentTextField: UITextField?

  fileprivate let addTag = "Add Tag"
  fileprivate var saveText = ""

  var suggestions: ((String, (([TagParser.TagContainer]) -> Void)) -> Void)?

  var tags: [String] = [] {
    didSet {
      self.set(Tags: self.tags)
    }
  }

  var textPass: ((String) -> Void)?

  private func set(Tags tags: [String]) {
    let final: [String] = [addTag] + tags
    tableDataSource.updateData([final])
  }

  @objc
  func done(_ button: UIBarButtonItem) {
    print("done")
  }

  @objc
  func cancel(_ button: UIBarButtonItem) {
//    presentSuggestionView()
//    textInput.text = saveText
  }

  @IBAction func close(_ sender: UIBarButtonItem) {
    //      if let inputText = self.textInput.text {
    //        self.textPass?(inputText)
    //      }

    self.dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    suggestionView.setSuggestion = { selection in
      if let command = selection.type, command.usesDatePicker {
        self.presentDatePicker(textField: self.currentTextField)

        let date = self.datePicker.date
//        self.textInput.text = FormatDate.format(date)
      }
    }
  }

  fileprivate func setupCell(cell: UITableViewCell, item: String, path: IndexPath) {
    let tempcell = cell as? TagTitleCell
    tempcell?.tagTitle = item
    tempcell?.fieldDelegate = self
  }

  fileprivate func presentSuggestionView(_ textField: UITextField) {
    let shouldReset = textField.inputAccessoryView != nil
    textField.inputView = nil
    textField.inputAccessoryView = suggestionView
    resetInputViews(shouldReset)
  }

  fileprivate func resetInputViews(_ reset: Bool) {
    if reset {
//      textInput.reloadInputViews()
    }
  }

  fileprivate func presentDatePicker(textField: UITextField?) {
    saveText = textField?.text ?? ""

    textField?.inputView = self.datePicker
    textField?.inputAccessoryView = self.datePickerToolbar
    textField?.reloadInputViews()
  }

  @objc func handleTap(_ sender: UITapGestureRecognizer) {
    dismiss(animated: true) {
//      if let inputText = self.textInput.text {
//        self.textPass?(inputText)
//      }
    }
  }
}

extension TextEntryController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    currentTextField = textField
    saveText = textField.text ?? ""
    if textField.text == addTag {
      textField.text = ""
    }
    presentSuggestionView(textField)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    currentTextField = nil
    if textField.text?.isEmpty ?? false {
      textField.text = saveText
    }
    saveText = ""
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let tagText = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)

    suggestions?(tagText) { suggestions in
      self.suggestionView.suggestions = suggestions
    }
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
