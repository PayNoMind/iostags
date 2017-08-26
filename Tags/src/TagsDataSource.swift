import Foundation

public protocol TagsDataSource {
  func getAllTags() -> Set<String>
  func getTagsByPrefix(_ prefix: String) -> [String]
  func insertTag(_: String)
  func insertTags(_ tags: Set<String>)
}
