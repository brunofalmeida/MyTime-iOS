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
    
    /// Tests writing a `DataModel` object to a file and reading the object back from the file
    func testCoding() {
        // Get the file URL
        guard let url = DataModel.documentsURL?.appendingPathComponent(
                "\(type(of: self))-\(#function).plist") else {
            XCTFail()
            return
        }
        
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
        XCTAssert(dataModel.writeToFile())
        print("Written data model:")
        debugPrint(dataModel)
        
        XCTAssert(FileManager.default.fileExists(atPath: url.path))
        
        // Read data
        if let readDataModel = DataModel.from(url: url) {
            print("Read data model:")
            debugPrint(readDataModel)
            
            XCTAssert(dataModel == readDataModel)
        } else {
            XCTFail()
        }
    }
    
}
