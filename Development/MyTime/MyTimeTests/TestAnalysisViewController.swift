//
//  TestAnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import XCTest
@testable import MyTime

class TestAnalysisViewController: XCTestCase {
    
    func testDateIntervalFormatting1() {
        // June 10, 2017, 9:41 PM
        let date = Date(timeIntervalSinceReferenceDate: 518838113)
        let interval = AnalysisViewController.dateInterval(forWeekOf: date)
        XCTAssertEqual(AnalysisViewController.format(dateInterval: interval), "June 5-11")
    }
    
    func testDateIntervalFormatting2() {
        // June 30, 2017, 9:16 PM
        let date = Date(timeIntervalSinceReferenceDate: 520564601)
        let interval = AnalysisViewController.dateInterval(forWeekOf: date)
        XCTAssertEqual(AnalysisViewController.format(dateInterval: interval), "June 26 - July 2")
    }
    
}
