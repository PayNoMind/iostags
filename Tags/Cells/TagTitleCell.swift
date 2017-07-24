//
//  TagTitleCell.swift
//  Tags
//
//  Created by Tom Clark on 2017-07-23.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import UIKit

class TagTitleCell: UITableViewCell {
  @IBOutlet weak var titleField: UITextField!

  var fieldDelegate: UITextFieldDelegate? {
    didSet {
      self.titleField.delegate = fieldDelegate
    }
  }

  var tagTitle: String {
    set {
      titleField.text = newValue
    }
    get {
      return titleField.text ?? ""
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    titleField.text = ""
  }
}
