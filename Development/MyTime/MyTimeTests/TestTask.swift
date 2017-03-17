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
    
    func testEqual() {
        XCTAssert(
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)) ==
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)))
        XCTAssertFalse(
            Task(name: "tes", timeInterval: TimeInterval(totalSeconds: 10)) ==
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)))
        XCTAssertFalse(
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 9)) ==
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)))
    }
    
    func testNotEqual() {
        XCTAssert(
            Task(name: "te", timeInterval: TimeInterval(totalSeconds: 9)) !=
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)))
        XCTAssertFalse(
            Task(name: "Work", timeInterval: TimeInterval(totalSeconds: 5)) !=
            Task(name: "Work", timeInterval: TimeInterval(totalSeconds: 5)))
    }
    
}
