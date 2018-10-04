//
//  Tag.swift
//  Tags
//
//  Created by Tom Clark on 2017-08-24.
//  Copyright © 2017 Fluiddynamics. All rights reserved.
//

import Foundation

public enum Tag {
  case addTag
  case tag(String)

  public var value: String {
    switch self {
    case .addTag:
      return "Add Tag"
    case .tag(let title):
      return title
    }
  }

  var suggestionTitle: String {
    switch self {
    case .addTag:
      return "Add Tag"
    case .tag(let title):
      return title
    }
  }
}

extension Tag: Equatable {}
extension Tag: Hashable {}

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
