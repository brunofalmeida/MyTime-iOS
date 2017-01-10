//
//  MyTimeTests.swift
//  MyTimeTests
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import XCTest
@testable import MyTime

class MyTimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTask() {
        XCTAssert(
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)) ==
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)))
        
        XCTAssertFalse(
            Task(name: "tes", timeInterval: TimeInterval(totalSeconds: 10)) ==
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)))
        XCTAssertFalse(
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 9)) ==
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)))
        XCTAssertFalse(
            Task(name: "tes", timeInterval: TimeInterval(totalSeconds: 9)) ==
            Task(name: "test", timeInterval: TimeInterval(totalSeconds: 10)))
    }
    
    func testTimeInterval() {
        XCTAssert(TimeInterval(totalSeconds: 9000) == TimeInterval(totalSeconds: 9000))
        XCTAssertFalse(TimeInterval(totalSeconds: 9000) == TimeInterval(totalSeconds: 9001))
    }
    
}
