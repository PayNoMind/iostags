import Foundation

public protocol TagsInterface {
  func getAllTags() -> Set<String>
  func getTagsByPrefix(prefix: String) -> [String]
  func insertTag(_: String)
}
