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
  var memory: TagsInterface!
  override func setUp() {
    super.setUp()
    memory = TagMemory()
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  func testGettingAllTags() {
    XCTAssertEqual(Set(["groceries", "home", "work", "stuff", "longstringthatislong"]), Set(memory.getAllTags()))
  }
  func testGetTagsByPrefix() {
    XCTAssertEqual(memory.getTagsByPrefix("g"), ["groceries"])
  }
  func testInsertTag() {
    memory.insertTag("cheeseburger")
    XCTAssertEqual(memory.getTagsByPrefix("c"), ["cheeseburger"])
  }
}
