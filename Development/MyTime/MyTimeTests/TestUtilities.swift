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
        // Saturday June 10, 2017, 9:41 PM
        XCTAssertEqual(Date(timeIntervalSinceReferenceDate: 518838113).dateInterval(for: .week).format(for: .week, stringLength: .long), "June 4 - 10")
    }
    
    func testDateIntervalFormatting2() {
        // Friday June 30, 2017, 9:16 PM
        XCTAssertEqual(Date(timeIntervalSinceReferenceDate: 520564601).dateInterval(for: .week).format(for: .week, stringLength: .long), "June 25 - July 1")
    }
    
}
