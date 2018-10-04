import Foundation

open class TagParser {
  private var tagHandler: TagsDataSource

  open var currentTags = [Tag]()

  private func getTagsThatMatch(Text text: String) -> [Tag] {
    let tags: [Tag] = tagHandler.getTagsByPrefix(text.lowercased()).map { tag -> Tag in
      return Tag.tag(tag)
    }
    return tags
  }

  open func parse(_ text: String) -> [Tag] {
    currentTags = getTagsThatMatch(Text: text)
    return currentTags
  }

  public init(tags: TagsDataSource) {
    self.tagHandler = tags
  }
}
