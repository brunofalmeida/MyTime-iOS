//
//  TestTask.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import XCTest
@testable import MyTime

class TestTask: XCTestCase {
    
    func testEqualOperator() {
        XCTAssert(
            Task(name: "test", startTime: Date(timeIntervalSince1970: 0), timeSpent: TimeInterval(totalSeconds: 10)) ==
            Task(name: "test", startTime: Date(timeIntervalSince1970: 0), endTime: Date(timeIntervalSince1970: 10)))
        XCTAssertFalse(
            Task(name: "tes", startTime: Date(timeIntervalSince1970: 0), timeSpent: TimeInterval(totalSeconds: 10)) ==
            Task(name: "test", startTime: Date(timeIntervalSince1970: 0), timeSpent: TimeInterval(totalSeconds: 10)))
        XCTAssertFalse(
            Task(name: "test", startTime: Date(timeIntervalSince1970: 0), timeSpent: TimeInterval(totalSeconds: 9)) ==
            Task(name: "test", startTime: Date(timeIntervalSince1970: 0), timeSpent: TimeInterval(totalSeconds: 10)))
    }
    
    func testNotEqualOperator() {
        XCTAssert(
            Task(name: "te", startTime: Date(timeIntervalSinceReferenceDate: 0), timeSpent: TimeInterval(totalSeconds: 9)) !=
            Task(name: "test", startTime: Date(timeIntervalSinceReferenceDate: 0), timeSpent: TimeInterval(totalSeconds: 10)))
        XCTAssertFalse(
            Task(name: "Work", startTime: Date(timeIntervalSinceReferenceDate: 0), timeSpent: TimeInterval(totalSeconds: 5)) !=
            Task(name: "Work", startTime: Date(timeIntervalSinceReferenceDate: 0), timeSpent: TimeInterval(totalSeconds: 5)))
    }
    
}
