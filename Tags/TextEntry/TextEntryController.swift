import UIKit

class TextEntryController: UIViewController {
  @IBOutlet private weak var tagTable: UITableView! {
    didSet {
      self.tagTable.registerNibWith(Title: TagTitleCell.nameString, withBundle: Bundle.tagBundle)
      self.tagTable.dataSource = self.tableDataSource
      self.tableDataSource.tableView = self.tagTable
      self.tagTable.delegate = self
    }
  }
  private lazy var tableDataSource: TableArrayDataSource<Tag> = {
    let temp = TableArrayDataSource<Tag>(anArray: [], withCellIdentifier: TagTitleCell.nameString, andCustomizeClosure: self.setupCell)
    return temp
  }()

  private lazy var datePicker: UIDatePicker = UIDatePicker()
  private lazy var datePickerToolbar: UIToolbar = {
    let toolBarFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35)
    let toolbar = UIToolbar(frame: toolBarFrame)
    toolbar.items = ([.cancel(self), .flexibleSpace, .done(self)] as [BarButtonHelper]).map { $0.button }
    return toolbar
  }()
  private lazy var suggestionView: SuggestionView = SuggestionView()
  private var currentTextField: UITextField?
  private var saveText = ""

  var suggestions: ((String, (([TagParser.TagContainer]) -> Void)) -> Void)?
  var tagPassBack: (([Tag]) -> Void)?

  var tags: [Tag] = [] {
    didSet {
      self.set(Tags: self.tags)
    }
  }

  private func set(Tags tags: [Tag]) {
    let final: [Tag] = [Tag.addTag] + (tags.contains(Tag.addTag) ? [] : tags)
    tableDataSource.updateData([final])
  }

  // Data Picker Buttons
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
  // End Data Picker Buttons

  @IBAction func close(_ sender: UIBarButtonItem) {
    if let text = currentTextField?.text, text != "" {
      tags.insert(Tag.tag(text), at: 0)
    }

    let final = removeAddTag()
    self.tagPassBack?(final)
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

  fileprivate func removeAddTag() -> [Tag] {
    return self.tags.filter { $0 != Tag.addTag }
  }

  fileprivate func setupCell(cell: UITableViewCell, item: Tag, path: IndexPath) {
    (cell as? TagTitleCell)?.tagValue = item
    (cell as? TagTitleCell)?.fieldDelegate = self
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

@available(iOS 11.0, *)
extension TextEntryController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .destructive, title: "Remove") { (_, _, success) in

      self.tags.remove(at: indexPath.row-1)
      self.set(Tags: self.tags)
      tableView.beginUpdates()
      tableView.deleteRows(at: [indexPath], with: .automatic)
      tableView.endUpdates()

      success(true)
    }
    action.backgroundColor = .red
    return UISwipeActionsConfiguration(actions: [action])
  }
}

extension TextEntryController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    currentTextField = textField
    saveText = textField.text ?? ""
    if textField.text == Tag.addTag.value {
      textField.text = ""
    }
    presentSuggestionView(textField)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.text?.isEmpty ?? true {
      textField.text = saveText
    } else {
      self.tags = removeAddTag()
      let tag = Tag.tag(textField.text ?? "")
      tags.insert(tag, at: 0)
      tags.insert(Tag.addTag, at: 0)
      set(Tags: self.tags)
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
