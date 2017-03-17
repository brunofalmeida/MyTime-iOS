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
    
//    override func setUp() {
//        super.setUp()
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
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
    
    func testPropertyListCoding() {
        // Set up file
        guard let documentsURL = DataModel.documentsURL else {
            XCTFail("Failed to get documents URL")
            return
        }
        
        let tasksURL = documentsURL.appendingPathComponent("\(type(of: self))-\(#function).plist")
        print("Path: \(tasksURL.path)")
        
        // Create data
        let tasks = [
            Task(name: "test1", timeInterval: TimeInterval(totalSeconds: 101)),
            Task(name: "test2", timeInterval: TimeInterval(totalSeconds: 2017))
        ]
        
        // Write data
        XCTAssert(NSKeyedArchiver.archiveRootObject(tasks, toFile: tasksURL.path))
        XCTAssert(FileManager.default.fileExists(atPath: tasksURL.path))
        
        // Read data
        if let readTasks = NSKeyedUnarchiver.unarchiveObject(withFile: tasksURL.path) as? [Task] {
            print("Written tasks:")
            print(tasks as NSArray)
            
            print("Read tasks:")
            print(readTasks as NSArray)
            
            XCTAssert(tasks == readTasks)
        } else {
            XCTFail("Failed to unarchive data from file")
        }
    }
    
    func testDataModelCoding() {
        // Set up file
        guard let documentsURL = DataModel.documentsURL else {
            XCTFail("Failed to get documents URL")
            return
        }
        
        let fileURL = documentsURL.appendingPathComponent("\(type(of: self))-\(#function).plist")
        print("Path: \(fileURL.path)")
        
        // Create data
        let dataModel = DataModel(priorities: [
            Priority(name: "Priority1", tasks: [
                Task(name: "Task11", timeInterval: TimeInterval(totalSeconds: 49)),
                Task(name: "Task12", timeInterval: TimeInterval(totalSeconds: 1500001))
            ]),
            Priority(name: "Priority2", tasks: [
                Task(name: "Task21", timeInterval: TimeInterval(totalSeconds: 1)),
                Task(name: "Task22", timeInterval: TimeInterval(totalSeconds: 99))
            ])
        ])
        
        // Write data
        XCTAssert(NSKeyedArchiver.archiveRootObject(dataModel, toFile: fileURL.path))
        XCTAssert(FileManager.default.fileExists(atPath: fileURL.path))
        
        // Read data
        if let readDataModel = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? DataModel {
            print("Written data model:")
            print(dataModel)
            
            print("Read data model:")
            print(readDataModel)
            
            XCTAssert(dataModel == readDataModel)
        } else {
            XCTFail("Failed to unarchive data from file")
        }
    }
    
}
