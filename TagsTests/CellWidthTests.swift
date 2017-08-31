//
//  CellWidthTests.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-29.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import XCTest
@testable import Tags

class CellWidthTests: XCTestCase {
  func standardFont() -> UIFont {
    return UIFont.systemFont(ofSize: 14.0)
  }

  func testCellWidth_shortTextWithStandardFont_returns34() {
    let font = self.standardFont()

    let cellWidth = CellWidth.widthOf(Text: "short", withFont: font)

    XCTAssertEqual(cellWidth, 34, accuracy: 0.1)
  }

  func testCellWidth_longTextWithStanderFont_returns66() {
    let font = self.standardFont()

    let cellWidth = CellWidth.widthOf(Text: "shorttexts", withFont: font)

    XCTAssertEqual(cellWidth, 66, accuracy: 0.5)
  }
}
