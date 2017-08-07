//
//  TextEntryController.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-29.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

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

  fileprivate lazy var datePicker: UIDatePicker = UIDatePicker()
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
  var tagPassBack: (([String]) -> Void)?

  var tags: [String] = [] {
    didSet {
      self.set(Tags: self.tags)
    }
  }

  private func set(Tags tags: [String]) {
    let final: [String] = [addTag] + tags
    tableDataSource.updateData([final])
  }

  @objc
  func done(_ button: UIBarButtonItem) {
    self.currentTextField?.resignFirstResponder()
    saveText = ""
  }

  @objc
  func cancel(_ button: UIBarButtonItem) {
    if let ctf = currentTextField {
      presentSuggestionView(ctf)
    }
    currentTextField?.text = saveText
  }

  @IBAction func close(_ sender: UIBarButtonItem) {
    self.tagPassBack?(self.tags)
    self.dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    suggestionView.setSuggestion = { selection in
      if let command = selection.type, command.usesDatePicker {
        self.presentDatePicker(textField: self.currentTextField)

        let date = self.datePicker.date
        self.currentTextField?.text = FormatDate.format(date)
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
      currentTextField?.reloadInputViews()
    }
  }

  fileprivate func presentDatePicker(textField: UITextField?) {
    saveText = textField?.text ?? ""
    self.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

    textField?.inputView = self.datePicker
    textField?.inputAccessoryView = self.datePickerToolbar
    textField?.reloadInputViews()
  }

  @objc
  func dateChanged(datePicker: UIDatePicker) {
    let date = datePicker.date
    self.currentTextField?.text = FormatDate.format(date)
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
    if textField.text?.isEmpty ?? true {
      textField.text = saveText
    } else {
      tags.insert(currentTextField?.text ?? "", at: 0)
      tags.insert(addTag, at: 0)
      tableDataSource.updateData([tags])
      tagTable.reloadData()
    }
    currentTextField = nil
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
