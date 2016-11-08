//
//  CompletionCell.swift
//  Tags
//
//  Created by Tom Clark on 2016-06-17.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import UIKit

class CompletionCell: UICollectionViewCell {
  @IBOutlet fileprivate weak var suggestedLabel: UILabel!

  var tagContainer: TagContainer = TagContainer(title: "")

  var title = "" {
    didSet {
      suggestedLabel.text = title
    }
  }
}
