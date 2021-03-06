//
//  DataModel.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation

/// The entire set of stored data for the application.
class DataModel: NSObject, NSCoding {
    
    static var `default`: DataModel = DataModel()
    
    static let defaultPriorityName = "General"
    static let defaultTaskName = "Untitled"
    
    /// All saved priorities.
    var priorities: [Priority]
    
    /// The default (General) priority.
    var defaultPriority: Priority? {
        ensureDefaultPriorityExists()
        
        for priority in priorities {
            if priority.name == DataModel.defaultPriorityName {
                return priority
            }
        }
        
        assertionFailure()
        return nil
    }
    
    /// All saved tasks.
    var allTasks: [Task] {
        return priorities.flatMap { $0.tasks }
    }
    
    init(priorities: [Priority] = []) {
        self.priorities = priorities
        
        super.init()
        
        ensureDefaultPriorityExists()
        ensureCorrect()
    }
    
    /// Adds the default priority if it does not exist.
    fileprivate func ensureDefaultPriorityExists() {
        if (!priorities.map { $0.name }.contains(DataModel.defaultPriorityName)) {
            priorities.insert(Priority(name: DataModel.defaultPriorityName), at: 0)
        }
    }
    
    /// Ensures that weak pointers from tasks to priorities exist
    fileprivate func ensureCorrect() {
        for priority in priorities {
            for task in priority.tasks {
                task.priority = priority
            }
        }
    }
    
    
    // MARK: - NSCoding
    
    /// Keys for encoding (writing) and decoding (reading) the object
    fileprivate enum CodingKeys: String {
        case priorities
    }
    
    // Decode (read)
    required convenience init?(coder aDecoder: NSCoder) {
        guard let priorities = aDecoder.decodeObject(forKey: CodingKeys.priorities.rawValue) as? [Priority] else {
            return nil
        }
        
        self.init(priorities: priorities)
    }
    
    // Encode (write)
    func encode(with aCoder: NSCoder) {
        aCoder.encode(priorities, forKey: CodingKeys.priorities.rawValue)
    }
    
    
    // MARK: - File I/O

    /// URL to documents directory
    static var documentsURL: URL? {
//        print(#function)
        
        // Look for app documents directory
        guard let directory = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true).first else {
            print("Couldn't find documents directory")
            return nil
        }
        
        // Convert documents directory from a string to a URL
        guard let url = URL(string: directory) else {
            print("Couldn't convert document directory to a URL")
            return nil
        }
        
        return url
    }
    
    /// Name of file to store the data model
    fileprivate static var dataModelFilePath = "DataModel.plist"
    
    /// URL to the main tasks file
    fileprivate static var dataModelURL: URL? {
        return documentsURL?.appendingPathComponent(dataModelFilePath)
    }
    
    
    
    /**
     This is synchronous because reading data from a file might be critical for the
     application to continue running, such as when the app starts.
     */
    static func readFromFile(url: URL? = dataModelURL) -> DataModel? {
        //print()
        print(#function)
        
        guard let url = url else {
            print("URL is nil")
            return nil
        }
        
//        print("Path: \(url.path)")
//        print("File existence: \(FileManager.default.fileExists(atPath: url.path))")
        
        if let readDataModel = NSKeyedUnarchiver.unarchiveObject(withFile: url.path) as? DataModel {
            print("Read succeeded")
            
            //print("Read data model:")
            //debugPrint(readDataModel)
            
            return readDataModel
        } else {
            print("Read failed")
            
            return nil
        }
    }
    
    
    /**
     Deletes a given file if it exists.
     
     This is synchronous because deleting a file might be critical for the
     application to continue running.
     */
    static func deleteFile(url: URL? = dataModelURL) {
        //print()
        print(#function)
        
        guard let url = url else {
            print("URL is nil")
            return
        }
        
//        print("Path: \(url.path)")
//        print("File existence: \(FileManager.default.fileExists(atPath: url.path))")
        
        do {
            try FileManager.default.removeItem(atPath: url.path)
            print("File deletion succeeded")
        } catch {
            print("File deletion failed")
        }
        
        print("File existence: \(FileManager.default.fileExists(atPath: url.path))")
    }
    
    /**
     This is asynchronous because writing the data to a file does not need to be
     done immediatey for the application to continue running.
     
     - Parameter result:
        A closure to execute after the file writing is done.
        The `Bool` passed to the closure will be `true` if the write operation was successful.
     */
    func writeToFile(url: URL? = dataModelURL, result: @escaping (Bool) -> Void = { _ in }) {
        DispatchQueue.global(qos: .background).async {
            //print()
            print(#function)
            
            guard let url = url else {
                print("URL is nil")
                assertionFailure()
                
                result(false)
                return
            }
            
    //        print("Path: \(url.path)")
            print("Data: \(self.debugDescription)")
    //        defer {
    //            print("File existence: \(FileManager.default.fileExists(atPath: url.path))")
    //        }
            
            if NSKeyedArchiver.archiveRootObject(self, toFile: url.path) {
                print("Write succeeded")
                
                result(true)
                
                //print("Written data model:")
                //debugPrint(self)
                
            } else {
                print("Write failed")
                assertionFailure()
                
                result(false)
            }
        }
    }
    
}


// MARK: - String Descriptions
extension DataModel {
    override var description: String {
        return type(of: self).description()
    }
    override var debugDescription: String {
        return "\(type(of: self))(priorities = \(priorities.map { $0.debugDescription } as NSArray))"
    }
}


// MARK: - Operators

func ==(left: DataModel, right: DataModel) -> Bool {
    return left.priorities == right.priorities
}

func !=(left: DataModel, right: DataModel) -> Bool {
    return !(left == right)
}



