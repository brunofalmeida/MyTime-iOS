//
//  Utilities.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation


extension Date {
    
    /// Gets date components for the current calendar.
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(components, from: self)
    }
    
    /// Gets a specific date component for the current calendar
    func component(_ component: Calendar.Component) -> Int? {
        return self.components([component]).value(for: component)
    }
    
    /// - Returns: The date interval for the week containing the date.
    func dateIntervalForWeek() -> DateInterval {
//        print(#function)
        
        let now = Date()
        var interval = DateInterval()
        
        // Monday, 0:00 AM
        var startMatching = DateComponents()
        startMatching.weekday = 2
        startMatching.hour = 0
        startMatching.minute = 0
        startMatching.second = 0
        startMatching.nanosecond = 0
        interval.start = Calendar.current.nextDate(after: self, matching: startMatching, matchingPolicy: .strict, repeatedTimePolicy: .last, direction: .backward) ?? now
        
        // Sunday, 11:59 PM
        var endMatching = DateComponents()
        endMatching.weekday = 1
        endMatching.hour = 23
        endMatching.minute = 59
        endMatching.second = 59
        endMatching.nanosecond = pow(base: 10, exponent: 8) - 1 // Using (10^9 - 1) would round to the next day
        interval.end = Calendar.current.nextDate(after: self, matching: endMatching, matchingPolicy: .strict, repeatedTimePolicy: .last, direction: .forward) ?? now
        
//        print("Interval: \(interval)")
        
        return interval
    }
    
}


extension DateInterval {
    
    /**
     Formats the date interval to a string with the months and days.
     For example, returns "June 5-11" (when the months are the same)
     or "June 26 - July 2" (when the months are different).
     */
    var formatForWeek: String {
        // TODO - update to use DateIntervalFormatter?
        
        var text = ""
        
        let startFormat = DateFormatter()
        let endFormat = DateFormatter()
        
        // Full month name (MMMM), day with at least 1 digit (d)
        startFormat.dateFormat = "MMMM d"
        text += "\(startFormat.string(from: start))"
        
        if start.component(.month) == end.component(.month) {
            // Same months
            text += "-"
            endFormat.dateFormat = "d"
        } else {
            // Different months
            text += " - "
            endFormat.dateFormat = "MMMM d"
        }
        
        text += "\(endFormat.string(from: end))"
        
        return text
    }
    
}


// TODO - Add search method - filter all tasks for those with specific parameters (priority, date interval, etc.)
// Can specify some parameters and not others
extension Array where Element == Task {
    
    /// The sum of the time spent on all tasks
    var totalTimeSpent: TimeInterval {
        return reduce(TimeInterval(totalSeconds: 0)) { (result, task) in
            result + task.timeSpent
        }
    }
}




/**
 A convenience function for printing an optional value without having to cast to Any.
 Not explicitly casting to Any produces a warning.
 */
func print(optional: Any?) {
    print(optional as Any)
}

/**
 A convenience function for taking Int powers without having to cast to Double.
 */
func pow(base: Int, exponent: Int) -> Int {
    return Int( pow(Double(base), Double(exponent)) )
}



