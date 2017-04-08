//
//  DataModel.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation

class DataModel: NSObject, NSCoding {
    
    static let defaultPriorityName = "General"
    
    var priorities: [Priority]
    
    init(priorities: [Priority] = []) {
        self.priorities = priorities
        
        // Add the default priority if it does not exist
        if (!priorities.map { priority in priority.name }.contains(type(of: self).defaultPriorityName)) {
            self.priorities.append(Priority(name: type(of: self).defaultPriorityName))
        }
    }
    
    
    // MARK: NSCoding
    
    /// Keys for reading/writing the object from/to a file
    fileprivate enum CodingKeys: String {
        case priorities
    }
    
    // Reads from file
    required convenience init?(coder aDecoder: NSCoder) {
        guard let priorities = aDecoder.decodeObject(forKey: CodingKeys.priorities.rawValue) as? [Priority] else {
            return nil
        }
        
        self.init(priorities: priorities)
    }
    
    // Writes to file
    func encode(with aCoder: NSCoder) {
        aCoder.encode(priorities, forKey: CodingKeys.priorities.rawValue)
    }
    

    /// URL to documents directory
    internal static var documentsURL: URL? {
        //print()
        print(#function)
        
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
    
    /// Name of actual file to store the data model
    fileprivate static var dataModelFilePath = "DataModel.plist"
    
    /// URL to the main tasks file
    fileprivate static var dataModelURL: URL? {
        return documentsURL?.appendingPathComponent(dataModelFilePath)
    }
    
    
    
    
    internal static func readFromFile(url: URL? = dataModelURL) -> DataModel? {
        //print()
        print(#function)
        
        guard let url = url else {
            print("URL is nil")
            return nil
        }
        
        print("Path: \(url.path)")
        print("File existence: \(FileManager.default.fileExists(atPath: url.path))")
        
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
    
    /// Deletes the file if it exists
    internal static func deleteFile(url: URL? = dataModelURL) {
        //print()
        print(#function)
        
        guard let url = url else {
            print("URL is nil")
            return
        }
        
        print("Path: \(url.path)")
        print("File existence: \(FileManager.default.fileExists(atPath: url.path))")
        
        do {
            try FileManager.default.removeItem(atPath: url.path)
            print("File deletion succeeded")
        } catch {
            print("File deletion failed")
        }
        
        print("File existence: \(FileManager.default.fileExists(atPath: url.path))")
    }
    
    /**
     - returns: true if the write operation succeeded
    */
    @discardableResult
    func writeToFile(url: URL? = dataModelURL) -> Bool {
        //print()
        print(#function)
        
        guard let url = url else {
            print("URL is nil")
            return false
        }
        
        print("Path: \(url.path)")
        defer {
            print("File existence: \(FileManager.default.fileExists(atPath: url.path))")
        }
        
        if NSKeyedArchiver.archiveRootObject(self, toFile: url.path) {
            print("Write succeeded")
            
            //print("Written data model:")
            //debugPrint(self)
            
            return true
        } else {
            print("Write failed")
            return false
        }
    }
    
}


extension DataModel {
    override var description: String {
        return type(of: self).description()
    }
    override var debugDescription: String {
        return "\(type(of: self))(priorities = \(priorities as NSArray))"
    }
}


func ==(left: DataModel, right: DataModel) -> Bool {
    return left.priorities == right.priorities
}

func !=(left: DataModel, right: DataModel) -> Bool {
    return !(left == right)
}



