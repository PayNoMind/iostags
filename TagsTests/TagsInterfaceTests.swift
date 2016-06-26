//
//  TagsTests.swift
//  TagsTests
//
//  Created by Tom Clark on 2015-10-16.
//  Copyright © 2015 Fluiddynamics. All rights reserved.
//

import XCTest
@testable import Tags

class TagsInterfaceTests: XCTestCase {
  var memory: TagsDataSource!
  override func setUp() {
    super.setUp()
    memory = TagMemory()
  }
    
  override func tearDown() {
    super.tearDown()
  }

  func testGettingAllTags() {
    XCTAssertEqual(Set(["groceries", "home", "work", "stuff", "longstringthatislong", "day"]), Set(memory.getAllTags()))
  }

  func testGetTagsByPrefix() {
    XCTAssertEqual(memory.getTagsByPrefix("g"), ["groceries"])
  }

  func testInsertTag() {
    memory.insertTag("cheeseburger")
    XCTAssertEqual(memory.getTagsByPrefix("c"), ["cheeseburger"])
  }
}
