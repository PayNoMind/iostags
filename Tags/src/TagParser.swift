import Foundation

public typealias TagContainer = TagParser.TagContainer

open class TagParser {
  fileprivate var tagHandler: TagsDataSource

  fileprivate(set) var commands = [CommandProtocol]()

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

  fileprivate func removeCommandPrefix(_ command: String) -> String? {
    return command.isCommand ? String(command.characters.dropFirst()) : nil
  }

  fileprivate func getCommandBy(Name name: String) -> TagContainer? {
    let type = commands.filter { value -> Bool in
      value.suggestionTitle.hasPrefix(name)
    }.first
    return TagContainer(commandType: type)
  }

  fileprivate func handleCommands(_ command: String) -> [TagContainer]? {
    guard let command = removeCommandPrefix(command)
      else { return nil }

    if command.isEmpty {
      return commands.map {
        TagContainer(commandType: $0)
      }.flatMap { $0 }
    }

    if let command = getCommandBy(Name: command.lowercased()) {
      return [command]
    }
    return nil
  }

  open func register(Command command: CommandProtocol) {
    commands.append(command)
  }

  fileprivate func setupDefaultCommands() {
    let commands: [CommandProtocol] = [Reminder(), DueDate()]
    for command in commands {
      self.register(Command: command)
    }
  }

  fileprivate func getTagsThatMatch(Text text: String) -> [TagContainer] {
    let tags: [TagContainer] = tagHandler.getTagsBy(Prefix: text.lowercased()).map { tag -> TagContainer in
      return TagContainer(title: tag)
    }
    return tags
  }

  open var currentTags = [TagContainer]()
  open func parse(_ text: String) -> [TagContainer] {
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
