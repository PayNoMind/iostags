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

  func testParse_getAllValuesWithLetter_ReturnsAllValuesMatchingLetter() {
    XCTAssertEqual(parser.parse("h").map { $0.title }, ["home"])
  }

  func testParse_LetterThatIsUpperCaseLetter_ReturnsAllValuesMatchingLetter() {
    XCTAssertEqual(parser.parse("H").map { $0.title }, ["home"])
  }

//  func testParse_AddLetterThenRemove_ReturnsEmptyArray() {
//    parser.parse("h")
//    XCTAssertEqual(parser.parse("").map { $0.title }, [])
//  }

  func testParse_CommandCharacter_ReturnsAllCommands() {
    XCTAssertEqual(Set(parser.parse(":").map { $0.title }), ["reminder", "duedate"])
  }

  func testParse_CommandThatMatchesLetterWithNoCommandPrefix_ReturnsEmptyArray() {
    XCTAssertEqual(parser.parse("r").map { $0.title }, [])
  }

  func testParse_CommandThatMatchesUpperCaseLetterWithCommandPrefix_ReturnsCommand() {
    XCTAssertEqual(parser.parse(":R").map { $0.title }, ["reminder"])
  }

  func testParse_CommandThatMatchesLetterWithCommandPrefix_ReturnsCommand() {
    XCTAssertEqual(parser.parse(":r").map { $0.title }, ["reminder"])
  }
}
