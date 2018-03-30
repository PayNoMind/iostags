//
//  Tag.swift
//  Tags
//
//  Created by Tom Clark on 2017-08-24.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import Foundation

public class SaveTag: NSObject, NSCoding {
  enum CoderTitle: String {
    case tagString
  }

  var tagString: String = ""

  public var toTag: Tag {
    return .tag(tagString)
  }

  public init(tag: Tag) {
    tagString = tag.value
  }

  required public init?(coder aDecoder: NSCoder) {
    self.tagString = aDecoder.decodeObject(forKey: CoderTitle.tagString.rawValue) as? String ?? ""
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(tagString, forKey: CoderTitle.tagString.rawValue)
  }
}

public enum Tag {
  static public func == (left: Tag, right: Tag) -> Bool {
    return left.value == right.value
  }

  case addTag
  case tag(String)
  case command(String, CommandProtocol?)

  public var value: String {
    switch self {
    case .addTag:
      return "Add Tag"
    case .tag(let title):
      return title
    case .command(let data):
      return data.1?.listTitle ?? ""
    }
  }

  var suggestionTitle: String {
    switch self {
    case .addTag:
      return "Add Tag"
    case .tag(let title):
      return title
    case .command(let data):
      return data.0
    }
  }

  public var command: CommandProtocol? {
    switch self {
    case .command(let data):
      return data.1
    default:
      return nil
    }
  }

  public var isCommand: Bool {
    switch self {
    case .command:
      return true
    default:
      return false
    }
  }
}

extension Tag: Codable {
  private enum CodingKeys: String, CodingKey {
    case tag
  }

  enum PostTypeCodingError: Error {
    case decoding(String)
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    if let value = try? values.decode(String.self, forKey: .tag) {
      self = .tag(value)
      return
    }
    throw PostTypeCodingError.decoding("Whoops!")
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .tag(let stuff):
      try container.encode(stuff, forKey: .tag)
    default:
      throw PostTypeCodingError.decoding("Whoops!")
    }
  }
}

extension Tag: Hashable {
  public var hashValue: Int {
    return self.value.hashValue &* 16777619
  }
}
