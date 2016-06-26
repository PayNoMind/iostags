import Foundation

public enum CommandType: String {
  case dueDate = "duedate"
  case reminder = "reminder"
  static let allValues = [dueDate, reminder]
}

extension String {
  var isCommand: Bool {
    let commandPrefix = ":"
    return self.hasPrefix(commandPrefix)
  }
}

public class TagParser {
  private var tagHandler: TagsDataSource

  public struct TagContainer {
    public let title: String
    public let type: CommandType?

    public var isCommand: Bool {
      return type != nil
    }

    init(title: String) {
      self.title = title
      self.type = nil
    }

    init?(commandType: CommandType?) {
      guard let commandType = commandType
        else { return nil }

      self.type = commandType
      self.title = commandType.rawValue
    }
  }

  private func removeCommandPrefix(command: String) -> String? {
    return command.isCommand ? String(command.characters.dropFirst()) : nil
  }

  private func getCommandBy(Name name: String) -> TagContainer? {
    let type = CommandType.allValues.filter { value -> Bool in
      value.rawValue.hasPrefix(name)
    }.first

    return TagContainer(commandType: type)
  }

  private func handleCommands(command: String) -> [TagContainer]? {
    guard let command = removeCommandPrefix(command)
      else { return nil }

    if command.isEmpty {
      return CommandType.allValues.map {
        TagContainer(commandType: $0)
      }.flatMap { $0 }
    }

    if let command = getCommandBy(Name: command.lowercaseString) {
      return [command]
    }

    return nil
  }

  private func getTagsThatMatch(Text text: String) -> [TagContainer] {
    let tags: [TagContainer] = tagHandler.getTagsByPrefix(text.lowercaseString).map { tag -> TagContainer in
      return TagContainer(title: tag)
    }
    return tags
  }

  public var currentTags = [TagContainer]()
  public func parse(text: String) -> [TagContainer] {
    if let tags = handleCommands(text) {
      currentTags = tags
    } else {
      currentTags = getTagsThatMatch(Text: text)
    }
    return currentTags
  }

  public init(tags: TagsDataSource) {
    self.tagHandler = tags
  }
}
