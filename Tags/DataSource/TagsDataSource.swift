import Foundation

public protocol TagsDataSource: class {
  func getAllTags() -> Set<String>
  func getTagsByPrefix(_ prefix: String) -> [String]
  func insertTag(_ tag: Tag)
  func insertTags(_ tags: Set<String>)
  func deleteTag(_ tag: String)
}
