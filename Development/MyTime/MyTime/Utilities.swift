//
//  Utilities.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation


/// The length of time for a date interval.
enum DateIntervalLength: String {
    
    case day = "Day"
    case week = "Week"
    case month = "Month"
    
    static let allCases: [DateIntervalLength] = [.day, .week, .month]
    
    var calendarComponent: Calendar.Component {
        switch self {
        case .day:
            return .day
        case .week:
            return .weekOfYear
        case .month:
            return .month
        }
    }
    
    var adjective: String {
        switch self {
        case .day:
            return "Daily"
        case .week:
            return "Weekly"
        case .month:
            return "Monthly"
        }
    }
}


extension Date {
    
    // Time unit conversions
    static let secondsPerMinute = 60
    static let minutesPerHour = 60
    static let hoursPerDay = 24
    
    static let secondsPerDay: Foundation.TimeInterval = Double(Date.secondsPerMinute * Date.minutesPerHour * Date.hoursPerDay)
    
    /// Gets date components for the current calendar.
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(components, from: self)
    }
    
    /// Gets a specific date component for the current calendar
    func component(_ component: Calendar.Component) -> Int? {
        return self.components([component]).value(for: component)
    }
    
    /// - Returns: The date interval for the given unit of time containing the date.
    func dateInterval(for length: DateIntervalLength) -> DateInterval {
        
        // Get the date interval for the unit of time containing this task
        if var interval = Calendar.current.dateInterval(of: length.calendarComponent, for: self) {
            
            // Subtract 1 ms from the end so the interval's string doesn't overlap to the next interval
            // e.g. July 2-8 and July 9-15 instead of July 2-9 and July 9-16
            interval.end -= 0.001
            
            return interval
            
        } else {
            assertionFailure()
            return DateInterval()
        }
    }
    
    /**
     Formats the date according to the given format string,
     without having to create a DateFormatter object.
     */
    func string(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /**
     Formats the date according to the given date and time styles,
     without having to create a DateFormatter object.
     */
    func string(withDateStyle dateStyle: DateFormatter.Style = .none, withTimeStyle timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }
    
}


extension DateInterval {
    
    /**
     Formats the date interval to a string with the months and days.
     For example, returns "June 5-11" (when the months are the same)
     or "June 26 - July 2" (when the months are different).
     */
    func format(for length: DateIntervalLength) -> String {
        // TODO - update to use DateIntervalFormatter?
        
        switch length {
            
        case .day:
            return start.string(withFormat: "MMMM d")
            
        case .week:
            var text = ""
            
            // Full month name (MMMM), day with at least 1 digit (d)
            text += start.string(withFormat: "MMMM d")
            
            if start.component(.month) == end.component(.month) {
                // If same month
                text += "-"
                text += end.string(withFormat: "d")
            } else {
                // If different months
                text += " - "
                text += end.string(withFormat: "MMMM d")
            }
            
            return text
            
        case .month:
            return start.string(withFormat: "MMMM")
        }
        
    }
    
}

extension Calendar.Component {
    func all() -> Set<Calendar.Component> {
        return [.calendar,
                .day,
                .era,
                .hour,
                .minute,
                .month,
                .nanosecond,
                .quarter,
                .second,
                .timeZone,
                .weekOfMonth,
                .weekOfYear,
                .weekday,
                .weekdayOrdinal,
                .year,
                .yearForWeekOfYear]
    }
}


// TODO - Add search method - filter all tasks for those with specific parameters
// (priority, date interval, etc.)
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
 Normally, not explicitly casting to Any produces a warning.
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



