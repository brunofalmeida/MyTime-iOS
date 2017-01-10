//
//  Task.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-29.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import Foundation

class Task {
    let name: String
    let timeInterval: TimeInterval
    
    init(name: String, timeInterval: TimeInterval) {
        self.name = name
        self.timeInterval = timeInterval
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
