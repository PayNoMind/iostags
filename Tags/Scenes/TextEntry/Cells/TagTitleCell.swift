//
//  TagTitleCell.swift
//  Tags
//
//  Created by Tom Clark on 2017-07-23.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import UIKit

class TagTitleCell: UITableViewCell {
  @IBOutlet private weak var titleField: UITextField!

  var fieldDelegate: UITextFieldDelegate? {
    didSet {
      self.titleField.delegate = fieldDelegate
    }
  }

  var tagValue: Tag {
    set {
      titleField.text = newValue.value
    }
    get {
      return Tag.tag(titleField.text ?? "")
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    titleField.text = ""
  }
}
