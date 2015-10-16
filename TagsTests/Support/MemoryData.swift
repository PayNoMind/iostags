import Foundation

class MemoryData {
  static let sharedInstance = MemoryData()
  private var _tags: Set = ["groceries", "home", "work", "stuff", "longstringthatislong"]

  class var tags: Set<String> {
    get {
    return sharedInstance._tags
    }
    set {
      sharedInstance._tags = newValue
    }
  }
}
