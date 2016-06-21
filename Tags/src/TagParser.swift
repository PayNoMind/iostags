import Foundation

public enum CommandType: String {
  case dueDate = "duedate"
  case reminder = "reminder"
  static let allValues = [dueDate, reminder]
}

public struct TagContainer {
  private var otherTags: [String]
  public let title: String
  public var isCommand: Bool = false
  public var type: CommandType?
  public var suggestedTypes: [String] {
    let temp = CommandType.allValues.filter { (value) -> Bool in
      value.rawValue.hasPrefix(title)
    }.map{ $0.rawValue }
    return temp + otherTags
  }
  init(title: String, otherTags tags: [String]=[], commandType type: CommandType?=nil) {
    self.title = title
    self.type = type
    self.otherTags = tags
    self.isCommand = type != nil
  }
}

public class TagParser {
  private let commandPrefix = ":"
  private var tagHandler: TagsInterface

  private func isCommand(command: String) -> Bool {
    return command.hasPrefix(commandPrefix)
  }

  private func handleCommands(command: String) -> TagContainer {
    let command = isCommand(command) ? String(command.characters.dropFirst()) : command
    let tags =  tagHandler.getTagsByPrefix(command)
    let type = CommandType(rawValue: command)
    return TagContainer(title: command, otherTags: tags, commandType: type)
  }

  public var currentContainer: TagContainer = TagContainer(title: "")
  public func parse(text: String) -> TagContainer {
    currentContainer = handleCommands(text)
    return currentContainer
  }

  public init(tags: TagsInterface) {
    self.tagHandler = tags
  }
}
