import Foundation

public protocol TagsDataSource {
  func getAllTags() -> Set<String>
  func getTagsBy(Prefix prefix: String) -> [String]
  func insert(Tag tag: String)
  func insert(Tags tags: Set<String>)
  func deleteTag(Tag tag: String)
}
