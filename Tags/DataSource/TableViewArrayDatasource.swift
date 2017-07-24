import UIKit

class TableArrayDataSource<T>: NSObject, UITableViewDataSource {
  fileprivate var dataArray: [[T]]
  fileprivate var cellIdentifier: String
  fileprivate var customizeCellClosure: (UITableViewCell, T, IndexPath) -> Void
  var cellIDClosure: ((IndexPath, T) -> String)?

  init(anArray dataArray: [[T]], withCellIdentifier cellIdentifier: String, andCustomizeClosure cellClosure: @escaping (UITableViewCell, T, IndexPath) -> Void) {
    self.dataArray = dataArray
    self.cellIdentifier = cellIdentifier
    self.customizeCellClosure = cellClosure
    super.init()
  }

  init(anArray dataArray: [[T]], withCellIDClosure idClosure: @escaping ((IndexPath, T) -> String), andCustomizeClosure cellClosure: @escaping (UITableViewCell, T, IndexPath) -> Void) {
    cellIdentifier = ""
    self.dataArray = dataArray
    self.cellIDClosure = idClosure
    self.customizeCellClosure = cellClosure
    super.init()
  }

  func updateData(_ dataArray: [[T]]) {
    self.dataArray = dataArray
  }

  func insertSection(_ section: [T], AtIndexPath indexPath: IndexPath) {
    dataArray.insert(section, at: (indexPath as NSIndexPath).section)
  }

  func removeSection(_ index: Int) {
    dataArray.remove(at: index)
  }

  func insertItem(_ item: T, atIndexPath indexPath: IndexPath) {
    dataArray[(indexPath as NSIndexPath).section].insert(item, at: (indexPath as NSIndexPath).row)
  }

  func removeItemAtIndexPath(_ indexPath: IndexPath) {
    dataArray[(indexPath as NSIndexPath).section].remove(at: (indexPath as NSIndexPath).row)
  }

  func updateItem(_ item: T, atIndexPath path: IndexPath) {
    dataArray[(path as NSIndexPath).section][(path as NSIndexPath).row] = item
  }

  func clearData() {
    dataArray.removeAll()
  }

  func itemAtIndexPath(_ indexPath: IndexPath) -> T {
    return dataArray[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
  }

  fileprivate func getCellId(_ path: IndexPath) -> String {
    guard let id = cellIDClosure
      else { return cellIdentifier }
    return id(path, dataArray[(path as NSIndexPath).section][(path as NSIndexPath).row])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray[section].count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return dataArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: getCellId(indexPath), for: indexPath)
    let item = itemAtIndexPath(indexPath)
    customizeCellClosure(cell, item, indexPath)
    return cell
  }
}
