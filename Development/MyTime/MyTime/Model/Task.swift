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
        case startTime
        case endTime
    }
    
    var name: String
    var priority: Priority?
    
    let startTime: Date
    let endTime: Date
    var timeSpent: TimeInterval {
        // Make it at least 1 second
        return TimeInterval(totalSeconds: Int( max(endTime.timeIntervalSince(startTime), 1) ))
    }
    
    
    init(name: String, startTime: Date, endTime: Date) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        super.init()
    }
    
    convenience init(name: String, startTime: Date, timeSpent: TimeInterval) {
        self.init(name: name, startTime: startTime, endTime: startTime + Double(timeSpent.totalSeconds))
    }
    
    
    // MARK: NSCoding
    
    // Write to file
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(startTime, forKey: CodingKeys.startTime.rawValue)
        aCoder.encode(endTime, forKey: CodingKeys.endTime.rawValue)
    }
    
    // Read from file
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String,
                let startTime = aDecoder.decodeObject(forKey: CodingKeys.startTime.rawValue) as? Date,
                let endTime = aDecoder.decodeObject(forKey: CodingKeys.endTime.rawValue) as? Date else {
            return nil
        }
        
        self.init(name: name, startTime: startTime, endTime: endTime)
    }
    
    func removeFromPriority() {
        priority?.removeTask(self)
    }
    
}


extension Task {
    override var description: String {
        return "\(name) (\(timeSpent))"
    }
    override var debugDescription: String {
        return "\(type(of: self))(name = \(name), priority = \(priority?.name ?? "")" +
            ", startTime = \(startTime), endTime = \(endTime), timeSpent = \(timeSpent.debugDescription))"
    }
}


func ==(left: Task, right: Task) -> Bool {
    return left.name == right.name && left.startTime == right.startTime && left.endTime == right.endTime
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



