//
//  CompletionCell.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-17.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

class CompletionCell: UICollectionViewCell {
  @IBOutlet private weak var suggestedLabel: UILabel!

  var title = "" {
    didSet {
      suggestedLabel.text = title
    }
  }
}
