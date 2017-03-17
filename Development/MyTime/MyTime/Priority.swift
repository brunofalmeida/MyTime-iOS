//
//  Priority.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation

class Priority: NSObject, NSCoding {
    
    fileprivate enum CodingKeys: String {
        case name
        case tasks
    }
    
    var name: String
    var tasks: [Task]
    
    init(name: String, tasks: [Task] = []) {
        self.name = name
        self.tasks = tasks
    }
    
    
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard   let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String,
                let tasks = aDecoder.decodeObject(forKey: CodingKeys.tasks.rawValue) as? [Task] else {
            return nil
        }
        
        print("name = \(name), tasks = \(tasks)")
        
        self.init(name: name, tasks: tasks)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(tasks as NSArray, forKey: CodingKeys.tasks.rawValue)
    }
    
}


// CustomStringConvertible, CustomDebugStringConvertible
extension Priority {
    
    override var description: String {
        var string = "\(name) [ "
        for task in tasks {
            string += "\(task), "
        }
        string += " ]"
        return string
    }
    
    override var debugDescription: String {
        return "\(name) \(tasks)"
    }
    
}

// Equatable
func ==(left: Priority, right: Priority) -> Bool {
    return left.name == right.name && left.tasks == right.tasks
}

func !=(left: Priority, right: Priority) -> Bool {
    return !(left == right)
}

/// Generic element-by-element Array comparison
func ==(left: [Priority], right: [Priority]) -> Bool {
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


