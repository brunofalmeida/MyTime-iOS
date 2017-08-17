//
//  Utilities.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation
import UIKit


/// The length of time that a date interval covers.
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


/// Unicode date/time formatting standard: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
extension Date {
    
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
    
    /// A length for string formatting.
    enum StringLength {
        case short
        case long
    }
    
    func string(withStringLength stringLength: StringLength) -> String {
        var format = ""
        
        switch stringLength {
            
        case .short:
            format = "EEE MMM d"
        case .long:
            format = "EEEE, MMMM d"
            
        }
        
        // If the year is not the current year, display it
        if component(.year) != Date().component(.year) {
            format = format + ", yyyy"
        }
        
        return self.format(withString: format)
    }
    
}


/// Unicode date/time formatting standard: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
extension DateInterval {
    
    /// A length for string formatting.
    enum StringLength {
        case short
        case long
    }
    
    /**
     Formats the date interval to a string with the months and days.
     For example, returns "June 5-11" (when the months are the same)
     or "June 26 - July 2" (when the months are different).
     */
    func format(for length: DateIntervalLength, stringLength: StringLength) -> String {
        if length == .day {
            return start.string(withStringLength: .short)
        }
        
        
        var format = ""
        
        switch stringLength {
        case .short:
            format += "MMM"
        case .long:
            format += "MMMM"
        }
        
        if length == .week {
            format += " d"
        }
        
        // If the year is not the current year, display it
        if start.component(.year) != Date().component(.year) {
            format += "yyyy"
        }
        
        let formatter = DateIntervalFormatter()
        formatter.dateTemplate = format
        return formatter.string(from: start, to: end)
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



