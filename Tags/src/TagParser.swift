import Foundation

extension String {
  var isCommand: Bool {
    let commandPrefix = ":"
    return self.hasPrefix(commandPrefix)
  }
}

public class TagParser {
  private var tagHandler: TagsDataSource

  private(set) var commands = [CommandProtocol]()

  public struct TagContainer {
    public let title: String
    public let type: CommandProtocol?

    public var isCommand: Bool {
      return type != nil
    }

    init(title: String) {
      self.title = title
      self.type = nil
    }

    init?(commandType: CommandProtocol?) {
      guard let commandType = commandType
        else { return nil }

      self.type = commandType
      self.title = commandType.suggestionTitle
    }
  }

  private func removeCommandPrefix(command: String) -> String? {
    return command.isCommand ? String(command.characters.dropFirst()) : nil
  }

  private func getCommandBy(Name name: String) -> TagContainer? {
    let type = commands.filter { value -> Bool in
      value.suggestionTitle.hasPrefix(name)
    }.first

    return TagContainer(commandType: type)
  }

  private func handleCommands(command: String) -> [TagContainer]? {
    guard let command = removeCommandPrefix(command)
      else { return nil }

    if command.isEmpty {
      return commands.map {
        TagContainer(commandType: $0)
      }.flatMap { $0 }
    }

    if let command = getCommandBy(Name: command.lowercaseString) {
      return [command]
    }

    return nil
  }

  public func register(Command command: CommandProtocol) {
    commands.append(command)
  }

  private func setupDefaultCommands() {
    let command = Reminder()
    self.register(Command: command)
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
    setupDefaultCommands()
  }
}
