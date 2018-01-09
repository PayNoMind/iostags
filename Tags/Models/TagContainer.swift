import Foundation

public class TagContainer {
  private var saveTag: Tag = Tag.tag("")
  var set: ((_ tags: OrderedSet<Tag>) -> Void)? {
    didSet {
      self.set?(self.tags)
    }
  }

  public var tags: OrderedSet<Tag> = [] {
    didSet {
      self.set?(self.tags)
    }
  }

  var currentTag: Tag = Tag.tag("")

  init(tags: [Tag]) {
    let final: [Tag] = [Tag.addTag] + (tags.contains(Tag.addTag) ? [] : tags)
    self.tags = OrderedSet<Tag>(final)
  }

  func startEditing(AtIndex index: Int) {
    saveTag = tags[index]
    currentTag = tags[index]
//    if saveTag == .addTag {
//      tags[index] = Tag.tag("")
//    }
  }

  func doneEditing(AtIndex index: Int) {
    if currentTag.value.isEmpty {
      // do nothing
      // reload
    }

    if saveTag.value != currentTag.value {

//      self.tags = self.removeAddTag()
      //todo handle this safer
//      tags.insert(currentTag, at: 0)

      tags.insert(currentTag, atIndex: index)
//      tags[index] = currentTag
      let final: [Tag] = [Tag.addTag] + tags //(tags.contains(Tag.addTag) ? [] : tags)
      let orderedSet = OrderedSet<Tag>(final)
      self.set?(orderedSet)
    }
  }

  func remove(AtIndex index: Int) {
    _ = tags.remove(At: index)
    self.set?(self.tags)
  }

  func removeAddTag() -> [Tag] {
    return self.tags.filter { $0 != Tag.addTag }
  }

  func insert(Tag tag: Tag) {
    tags.insert(tag, atIndex: 0)
    tags.insert(Tag.addTag, atIndex: 0)
    self.set?(self.tags)
  }
}
