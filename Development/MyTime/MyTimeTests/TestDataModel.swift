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
    
    func testCoding() {
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
