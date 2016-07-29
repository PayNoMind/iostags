//
//  FormatDateTests.swift
//  Tags
//
//  Created by Tom Clark on 2016-07-26.
//  Copyright © 2016 Fluiddynamics. All rights reserved.
//

import XCTest
@testable import Tags

class FormatDateTests: XCTestCase {
  func testFormat_currentDateFormatIsMediumStyle_returnsCorrectlyFormatedString() {
    let currentDate = NSDate()

    let localFormatter = NSDateFormatter()
    localFormatter.dateStyle = .MediumStyle

    let format = FormatDate.format(currentDate)

    XCTAssertEqual(format, localFormatter.stringFromDate(currentDate))
  }
}
