//
//  TagTitleCellVM.swift
//  Tags
//
//  Created by Tom Clark on 2018-10-04.
//  Copyright © 2018 Fluiddynamics. All rights reserved.
//

import Foundation

class TagTitleCellVM {
  private let tag: Tag

  init(tag: Tag) {
    self.tag = tag
  }
}

//import UIKit
//
//class SubTaskCellViewModel {
//  private var task: Task
//
//  // View Bindings
//  private(set)var didChangeText: ((String) -> Void)?
//
//  var updateTask: ((Task, String) -> Void)?
//
//  var title: String {
//    return task.title
//  }
//
//  init(task: Task) {
//    self.task = task
//    self.didChangeText = { text in
//      let oldTask = self.task
//      self.task.title = text
//      self.updateTask?(oldTask, text)
//    }
//  }
//}
//
//extension SubTaskCellViewModel: CellRepresentable {
//  static var cellName: String {
//    return SubTaskCell.name
//  }
//
//  func cellSelected() {}
//
//  func customizeCell(_ cell: UITableViewCell) {
//    let newCell = cell as! SubTaskCell
//    newCell.setup(self)
//  }
//}
