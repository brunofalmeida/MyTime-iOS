//
//  TestDataModel.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import XCTest
@testable import MyTime

class TestDataModel: XCTestCase {
    
    func test() {
        // Delete main data model file
        //DataModel.deleteFile()
    }
    
    /// Tests writing a `DataModel` object to a file and reading the object back from the file
    func testCoding() {
        // Get the file URL
        guard let url = DataModel.documentsURL?.appendingPathComponent(
                "\(type(of: self))-\(#function).plist") else {
            XCTFail()
            return
        }
        
        print("Path: \(url.path)")
        
        // Create data
        let dataModel = DataModel(priorities: [
            Priority(name: "Priority1", tasks: [
                Task(name: "Task11", startTime: Date(timeIntervalSince1970: 0), endTime: Date(timeIntervalSinceReferenceDate: 1)),
                Task(name: "Task12", startTime: Date(timeIntervalSince1970: 0), timeSpent: TimeInterval(totalSeconds: 1500001))
            ]),
            Priority(name: "Priority2", tasks: [
                Task(name: "Task21", startTime: Date(timeIntervalSinceReferenceDate: 0), timeSpent: TimeInterval(totalSeconds: 42)),
                Task(name: "Task22", startTime: Date(timeIntervalSince1970: 0), timeSpent: TimeInterval(totalSeconds: 99))
            ])
        ])
        
        // Delete existing file
        DataModel.deleteFile(url: url)
        XCTAssertFalse(FileManager.default.fileExists(atPath: url.path))
        
        // Write data
        XCTAssert(dataModel.writeToFile(url: url))
        print("Written data model:")
        debugPrint(dataModel)
        XCTAssert(FileManager.default.fileExists(atPath: url.path))
        
        // Read data
        if let readDataModel = DataModel.readFromFile(url: url) {
            print("Read data model:")
            debugPrint(readDataModel)
            
            XCTAssert(dataModel == readDataModel)
        } else {
            XCTFail()
        }
    }
    
}
