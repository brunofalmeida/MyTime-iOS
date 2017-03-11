//
//  DataModel.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation

class DataModel {
    var priorities: [Priority] = []
    
//    // Load tasks from file
//    tasks = readTasksFromFile() ?? []
    
    func update() {
        
    }
    
    
    /// URL to documents directory
    fileprivate static var documentsURL: URL? {
        //print()
        //print("documentsURL")
        
        // Look for app documents directory
        guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true).first else {
                print("Couldn't find document directory")
                return nil
        }
        
        // Convert documents directory from a string to a URL
        guard let documentsURL = URL(string: documentsDirectory) else {
            print("Couldn't convert document directory to a URL")
            return nil
        }
        
        return documentsURL
    }
    
    /// The tasks URL, with the output file name appended
    fileprivate static var tasksURL: URL? {
        return documentsURL?.appendingPathComponent("Tasks.plist")
    }
    
    
    
//    func writeToFile(tasks: [Task]) {
//        print()
//        print("writeTasksToFile()")
//        
//        guard let tasksURL = self.tasksURL else {
//            print("tasksURL doesn't exist")
//            return
//        }
//        
//        print("File: \(tasksURL.path)")
//        print("Tasks:")
//        print(tasks as NSArray)
//        
//        if NSKeyedArchiver.archiveRootObject(tasks, toFile: tasksURL.path) {
//            print("Write succeeded")
//        } else {
//            print("Write failed")
//        }
//        
//        print("File existence: \(FileManager.default.fileExists(atPath: tasksURL.path))")
//    }
//    
//    func readFromFile() -> [Task]? {
//        print()
//        print("readTasksFromFile()")
//        
//        guard let tasksURL = self.tasksURL else {
//            print("tasksURL doesn't exist")
//            return nil
//        }
//        
//        print("File: \(tasksURL.path)")
//        print("File existence: \(FileManager.default.fileExists(atPath: tasksURL.path))")
//        
//        if let readTasks = NSKeyedUnarchiver.unarchiveObject(withFile: tasksURL.path) as? NSArray {
//            print("Read succeeded")
//            print("Read tasks:")
//            print(readTasks)
//            
//            // Convert from NSArray to Swift Array
//            if let readTasksSwiftArray = readTasks as? [Task] {
//                return readTasksSwiftArray
//            } else {
//                print("Failed to convert tasks from NSArray to [Task]")
//            }
//        } else {
//            print("Read failed")
//        }
//        
//        return nil
//    }
    
    
}
