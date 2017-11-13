import UIKit

class TableArrayDataSource<T>: NSObject, UITableViewDataSource {
  typealias CustomizeCell = (UITableViewCell, T, IndexPath) -> Void

  fileprivate var dataArray: [[T]]
  fileprivate var cellIdentifier: String
  fileprivate var customizeCellClosure: (UITableViewCell, T, IndexPath) -> Void
  var cellIDClosure: ((IndexPath, T) -> String)?
  var tableView: UITableView?

  init(anArray dataArray: [[T]], withCellIdentifier cellIdentifier: String, andCustomizeClosure cellClosure: @escaping CustomizeCell) {
    self.dataArray = dataArray
    self.cellIdentifier = cellIdentifier
    self.customizeCellClosure = cellClosure
    super.init()
  }

  init(anArray dataArray: [[T]], withCellIDClosure idClosure: @escaping ((IndexPath, T) -> String), andCustomizeClosure cellClosure: @escaping CustomizeCell) {
    cellIdentifier = ""
    self.dataArray = dataArray
    self.cellIDClosure = idClosure
    self.customizeCellClosure = cellClosure
    super.init()
  }

  func updateData(_ dataArray: [[T]]) {
    self.dataArray = dataArray
    tableView?.reloadData()
  }

  func insertSection(_ section: [T], AtIndexPath indexPath: IndexPath) {
    dataArray.insert(section, at: indexPath.section)
  }

  func removeSection(Index index: Int) {
    dataArray.remove(at: index)
  }

  func insert(Item item: T, atIndexPath path: IndexPath) {
    dataArray[path.section].insert(item, at: path.row)
    self.tableView?.beginUpdates()
    self.tableView?.insertRows(at: [path], with: .fade)
    self.tableView?.endUpdates()
  }

  func removeItemAt(IndexPath path: IndexPath) {
    dataArray[path.section].remove(at: path.row)
    self.tableView?.beginUpdates()
    self.tableView?.deleteRows(at: [path], with: .fade)
    self.tableView?.endUpdates()
  }

  func updateItem(_ item: T, atIndexPath path: IndexPath) {
    dataArray[path.section][path.row] = item
    self.tableView?.beginUpdates()
    self.tableView?.reloadRows(at: [path], with: .fade)
    self.tableView?.endUpdates()
  }

  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    NSLog("test")
  }

  func clearData() {
    dataArray.removeAll()
  }

  func itemAt(IndexPath indexPath: IndexPath) -> T {
    return dataArray[indexPath.section][indexPath.row]
  }

  fileprivate func getCellId(_ path: IndexPath) -> String {
    guard let id = cellIDClosure
      else { return cellIdentifier }
    return id(path, dataArray[path.section][path.row])
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray[section].count
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return dataArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: getCellId(indexPath), for: indexPath)
    let item = itemAt(IndexPath: indexPath)
    customizeCellClosure(cell, item, indexPath)
    return cell
  }
}
