//
//  Priority.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation

/// One of the user's priorities, such as programming, design, or reading.
class Priority: NSObject, NSCoding {
    
    fileprivate enum CodingKeys: String {
        case name
        case tasks
    }
    
    var name: String
    private(set) var tasks: [Task]
    
    init(name: String, tasks: [Task] = []) {
        self.name = name
        self.tasks = tasks
        super.init()
    }
    
    
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String,
                let tasks = aDecoder.decodeObject(forKey: CodingKeys.tasks.rawValue) as? [Task] else {
            return nil
        }
        
        self.init(name: name, tasks: tasks)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(tasks as NSArray, forKey: CodingKeys.tasks.rawValue)
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        task.priority = self
    }
    
    func removeTask(at index: Int) {
        let task = tasks.remove(at: index)
        task.priority = nil
    }
    
    func removeTask(_ task: Task) {
        if let index = tasks.index(of: task) {
            removeTask(at: index)
        } else {
            assertionFailure()
        }
    }
    
}


extension Priority {
    override var description: String {
        return name
    }
    override var debugDescription: String {
        return "\(type(of: self))(name = \(name), tasks = \(tasks.map { $0.name })"
    }
}


func ==(left: Priority, right: Priority) -> Bool {
    return left.name == right.name && left.tasks == right.tasks
}

func !=(left: Priority, right: Priority) -> Bool {
    return !(left == right)
}

/// Generic element-wise Array comparison
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



