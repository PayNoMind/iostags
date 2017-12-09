import Foundation

public class TagContainer {
  private var saveTag: Tag = Tag.tag("")
  var set: ((_ tags: [Tag]) -> Void)? {
    didSet {
      self.set?(self.tags)
    }
  }

  public var tags: [Tag] = [] {
    didSet {
      self.set?(self.tags)
    }
  }

  var currentTag: Tag = Tag.tag("")

  init(tags: [Tag]) {
    let final: [Tag] = [Tag.addTag] + (tags.contains(Tag.addTag) ? [] : tags)
    self.tags = final
  }

  func startEditing(AtIndex index: Int) {
    saveTag = tags[index]
    currentTag = tags[index]
  }

  func doneEditing(AtIndex index: Int) {
    if currentTag.value.isEmpty {
      // do nothing
      // reload
    }

    if saveTag.value != currentTag.value {
      self.tags = self.removeAddTag()
      //todo handle this safer
      tags[index-1] = currentTag
      let final: [Tag] = [Tag.addTag] + (tags.contains(Tag.addTag) ? [] : tags)
      self.set?(final)
    }
  }

  func remove(AtIndex index: Int) {
    tags.remove(at: index)
    self.set?(self.tags)
  }

  func removeAddTag() -> [Tag] {
    return self.tags.filter { $0 != Tag.addTag }
  }

  func insert(Tag tag: Tag) {
    tags.insert(tag, at: 0)
    tags.insert(Tag.addTag, at: 0)
    self.set?(self.tags)
  }
}
