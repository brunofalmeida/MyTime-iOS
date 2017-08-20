//
//  Task.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-29.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import Foundation

/// An activity or event that the user keeps track of.
class Task: NSObject, NSCoding {
    
    /// Keys for reading/writing the object from/to a file
    fileprivate enum CodingKeys: String {
        case name
        case startTime
        case endTime
        case notes
    }
    
    var name: String
    var priority: Priority?
    
    var startTime: Date {
        didSet {
            validateStartAndEndTimes()
        }
    }
    var endTime: Date {
        didSet {
            validateStartAndEndTimes()
        }
    }
    var dateInterval: DateInterval {
        return DateInterval(start: startTime, end: endTime)
    }
    
    var timeSpent: TimeInterval {
        // Make it at least 1 second
        return TimeInterval(totalSeconds:
            Int( max(endTime.timeIntervalSince(startTime), 1) ))
    }
    
    var notes: String = ""
    
    
    
    
    init(name: String, startTime: Date, endTime: Date, notes: String? = nil) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.notes = notes ?? ""
        
        super.init()
    }
    
    convenience init(name: String,
                     startTime: Date,
                     timeSpent: TimeInterval,
                     notes: String? = nil) {
        self.init(name: name,
                  startTime: startTime,
                  endTime: startTime + Double(timeSpent.totalSeconds),
                  notes: notes)
    }
    
    /// Ensures `startTime` and `endTime` are valid with respect to each other.
    func validateStartAndEndTimes() {
        // While end time comes before start time, add 1 day to end time
        while endTime < startTime {
            endTime += Date.secondsPerDay
        }
        
        // While end time is more than 24 hours after start time, subtract 1 day from end time
        while endTime >= startTime + Date.secondsPerDay {
            endTime -= Date.secondsPerDay
        }
    }
    
    
    // MARK: NSCoding
    
    // Write to file
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(startTime, forKey: CodingKeys.startTime.rawValue)
        aCoder.encode(endTime, forKey: CodingKeys.endTime.rawValue)
        aCoder.encode(notes, forKey: CodingKeys.notes.rawValue)
    }
    
    // Read from file
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String,
                let startTime = aDecoder.decodeObject(forKey: CodingKeys.startTime.rawValue) as? Date,
                let endTime = aDecoder.decodeObject(forKey: CodingKeys.endTime.rawValue) as? Date else {
            return nil
        }
        
        let notes = aDecoder.decodeObject(forKey: CodingKeys.notes.rawValue) as? String
        
        self.init(name: name, startTime: startTime, endTime: endTime, notes: notes)
    }
    
    func removeFromPriority() {
        priority?.removeTask(self)
    }
    
    func addToPriority(priority: Priority) {
        priority.addTask(self)
    }
    
}


extension Task {
    override var description: String {
        return "\(name) (\(timeSpent))"
    }
    override var debugDescription: String {
        return "\(type(of: self))(name = \(name), priority = \(priority?.name ?? "")" +
            ", startTime = \(startTime), endTime = \(endTime), timeSpent = \(timeSpent.debugDescription), notes = \(notes))"
    }
}


func ==(left: Task, right: Task) -> Bool {
    return left.name == right.name &&
        left.startTime == right.startTime &&
        left.endTime == right.endTime
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



