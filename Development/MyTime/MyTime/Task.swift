//
//  Task.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-29.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import Foundation


/// A distinct activity or event for the user to keep track of
class Task: NSObject, NSCoding {
    
    /// Keys for reading/writing the object from/to a file
    fileprivate enum CodingKeys: String {
        case name
        case timeSpent
    }
    
    var priority: Priority? = nil
    var name: String
    let timeSpent: TimeInterval
    
    init(name: String, timeSpent: TimeInterval) {
        self.name = name
        self.timeSpent = timeSpent
        super.init()
    }
    
    
    // MARK: NSCoding
    
    // Read the object from a file
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String,
                let timeSpent = aDecoder.decodeObject(forKey: CodingKeys.timeSpent.rawValue) as? TimeInterval else {
            return nil
        }
        
        self.init(name: name, timeSpent: timeSpent)
    }
    
    // Write the object to a file
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(timeSpent, forKey: CodingKeys.timeSpent.rawValue)
    }
    
}


extension Task {
    override var description: String {
        return "\(name) (\(timeSpent))"
    }
    override var debugDescription: String {
        return "\(type(of: self))(name = \(name), timeSpent = \(timeSpent.debugDescription))"
    }
}


func ==(left: Task, right: Task) -> Bool {
    return left.name == right.name && left.timeSpent == right.timeSpent
}

func !=(left: Task, right: Task) -> Bool {
    return !(left == right)
}

func ==(left: [Task], right: [Task]) -> Bool {
    guard left.count == right.count else {
        return false
    }
    
    for i in 0 ..< left.count {
        if left[i] != right[i] {
            return false
        }
    }
    
    return true
}



