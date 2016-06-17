//
//  TagParserTests.swift
//  Tags
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2015 Fluiddynamics. All rights reserved.
//

import XCTest
@testable import Tags

class TagParserTests: XCTestCase {
  var parser: TagParser!
    
  override func setUp() {
    super.setUp()
    let interface = TagMemory()
    parser = TagParser(tags: interface)
  }
    
  override func tearDown() {
    super.tearDown()
  }

  func testParser() {
    XCTAssertEqual(parser.parse("h").suggestedTypes, ["home"])
  }

  func testCommand() {
    XCTAssertEqual(parser.parse(":r").suggestedTypes, ["reminder"])
  }
}
