//
//  Task.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-29.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import Foundation

class Task: NSCoding {
    
    fileprivate enum CodingKeys: String {
        case name
        case timeInterval
    }
    
    let name: String
    let timeInterval: TimeInterval
    
    init(name: String, timeInterval: TimeInterval) {
        self.name = name
        self.timeInterval = timeInterval
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String,
            let timeInterval = aDecoder.decodeObject(forKey: CodingKeys.timeInterval.rawValue) as? TimeInterval
            else { return nil }
        
        self.init(name: name, timeInterval: timeInterval)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(timeInterval, forKey: CodingKeys.timeInterval.rawValue)
    }
    
}

extension Task: CustomStringConvertible {
    var description: String {
        return "\(name) (\(timeInterval))"
    }
}

extension Task: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Task(name = \(name), timeInterval = \(timeInterval.debugDescription))"
    }
}
