//
//  TestTimeInterval.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import XCTest
@testable import MyTime

class TestTimeInterval: XCTestCase {
    
    func testTimeInterval() {
        XCTAssert(TimeInterval(totalSeconds: 9000) == TimeInterval(totalSeconds: 9000))
        XCTAssertFalse(TimeInterval(totalSeconds: 9000) == TimeInterval(totalSeconds: 9001))
    }
    
}
