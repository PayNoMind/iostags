import Foundation

public protocol TagsDataSource: class {
  func getAllTags() -> Set<String>
  func getTagsBy(Prefix prefix: String) -> [String]
  func insertTag(_ tag: Tag)
  func insert(Tags tags: Set<String>)
  func deleteTag(Tag tag: String)
}
