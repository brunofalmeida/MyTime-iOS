//
//  TestUtilities.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import XCTest
@testable import MyTime

class TestUtilities: XCTestCase {
    
    func testDateIntervalFormatting1() {
        // June 10, 2017, 9:41 PM
        XCTAssertEqual(Date(timeIntervalSinceReferenceDate: 518838113).dateIntervalForWeek().formatForWeek, "June 5-11")
    }
    
    func testDateIntervalFormatting2() {
        // June 30, 2017, 9:16 PM
        XCTAssertEqual(Date(timeIntervalSinceReferenceDate: 520564601).dateIntervalForWeek().formatForWeek, "June 26 - July 2")
    }
    
}
