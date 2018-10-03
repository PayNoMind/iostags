import UIKit

class TagEntryController: UIViewController {
  @IBOutlet private weak var tagTable: UITableView! {
    didSet {
      self.tagTable.registerNibWithTitle(TagTitleCell.nameString, withBundle: Bundle.tagBundle)
      self.tagTable.dataSource = self.tableDataSource
      self.tableDataSource.tableView = self.tagTable
      self.tagTable.delegate = self
    }
  }
  private lazy var tableDataSource: TableArrayDataSource<Tag> = {
    let temp = TableArrayDataSource<Tag>(anArray: [], withCellIdentifier: TagTitleCell.nameString, andCustomizeClosure: self.setupCell)
    return temp
  }()
  private lazy var datePicker: UIDatePicker = {
    let picker = UIDatePicker()
    picker.minimumDate = Date()
    return picker
  }()
  private lazy var datePickerToolbar: UIToolbar = {
    let toolBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
    let toolbar = UIToolbar(frame: toolBarFrame)
    toolbar.items = ([.cancel(self), .flexibleSpace, .done(self)] as [BarButtonHelper]).map { $0.button }
    return toolbar
  }()
  private lazy var suggestionView: SuggestionView = SuggestionView(suggestion: self.setSuggestion)
  private var currentTextField: UITextField? {
    return UIResponder.first as? UITextField
  }

  var suggestions: ((String, (([Tag]) -> Void)) -> Void)?
  var tagPassBack: (([Tag]) -> Void)?

  var tags: TagContainer = TagContainer(tags: []) {
    didSet {
      self.tags.set = self.set
    }
  }

  private func set(Tags tags: OrderedSet<Tag>) {
    tableDataSource.updateData([tags.contents])
  }

  // Data Picker Buttons
  @objc
  func done(_ button: UIBarButtonItem) {
    // current cell tag execute
    currentTextField?.resignFirstResponder()
  }

  @objc
  func cancel(_ button: UIBarButtonItem) {
    if let ctf = currentTextField {
      presentSuggestionView(ctf)
    }
  }
  // End Data Picker Buttons

  @IBAction func close(_ sender: UIBarButtonItem) {
    if let text = currentTextField?.text, text != "" {
      tags.insert(Tag: Tag.tag(text))
    }

    let final = self.tags.removeAddTag()
    self.tagPassBack?(final)
    self.dismiss(animated: true, completion: nil)
  }

  private func setupCell(cell: UITableViewCell, item: Tag, path: IndexPath) {
    (cell as? TagTitleCell)?.tagValue = item
    (cell as? TagTitleCell)?.fieldDelegate = self
  }

  private func presentSuggestionView(_ textField: UITextField) {
    let shouldReset = textField.inputAccessoryView != nil
    textField.inputView = nil
    textField.inputAccessoryView = suggestionView
    resetInputViews(shouldReset)
  }

  private func resetInputViews(_ reset: Bool) {
    if reset {
      currentTextField?.reloadInputViews()
    }
  }

  private func setSuggestion(ByTag tag: Tag) {
    self.tags.currentTag = tag
    currentTextField?.text = tag.value
  }

  private func getCurrentCell(FromTextField textfield: UITextField) -> TagTitleCell? {
    guard let index = self.getIndex(FromTextField: textfield)
      else { return nil }
    return self.tagTable.cellForRow(at: index) as? TagTitleCell
  }
}

@available(iOS 11.0, *)
extension TagEntryController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Remove") { (_, _, success) in
      self.tags.remove(AtIndex: indexPath.row-1)
      self.tableDataSource.removeItemAt(IndexPath: indexPath)
      success(true)
    }
    action.backgroundColor = .red
    return UISwipeActionsConfiguration(actions: [action])
  }
}

extension TagEntryController: UITextFieldDelegate {
  private func getSuggestions(byText text: String) {
    suggestions?(text) { suggestions in
      self.suggestionView.suggestions = suggestions
    }
  }

  private func getIndex(FromTextField textField: UITextField) -> IndexPath? {
    let point = textField.convert(textField.frame.origin, to: self.tagTable)
    return self.tagTable.indexPathForRow(at: point)
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    getSuggestions(byText: "")
    if let index = getIndex(FromTextField: textField) {
      tags.startEditing(AtIndex: index.row)
      presentSuggestionView(textField)
      if tags.currentTag == .addTag {
        textField.text = ""
      }
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if let index = getIndex(FromTextField: textField) {
      self.tags.doneEditing(AtIndex: index.row)
    }
    if !(textField.text?.isEmpty ?? false) {
      tagTable.reloadData()
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let tagText: String = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
    self.tags.currentTag = Tag.tag(tagText)
    getSuggestions(byText: tagText)
    return true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
