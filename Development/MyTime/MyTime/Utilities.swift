//
//  Utilities.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation
import UIKit

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
    
    /// A length for string formatting.
    enum StringLength {
        case short
        case long
    }
    
    func string(withStringLength stringLength: StringLength) -> String {
        switch stringLength {
            
        case .short:
            return string(withFormat: "EEE MMM d")
        case .long:
            return string(withFormat: "EEEE, MMMM d")
            
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

// Unicode date/time formatting standard: http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns

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
        // TODO - update to use DateIntervalFormatter?
        
        // Use short format by default
        var dayFormat = "MMM d"
        var monthFormat = "MMM"
        
        // If long format
        if stringLength == .long {
            dayFormat = "MMMM d"
            monthFormat = "MMMM"
        }
        
        switch length {
            
        case .day:
            return start.string(withFormat: dayFormat)
            
        case .week:
            var text = ""
            
            text += start.string(withFormat: dayFormat)
            
            if start.component(.month) == end.component(.month) {
                // If same month
                text += "-"
                text += end.string(withFormat: "d")
            } else {
                // If different months
                text += " - "
                text += end.string(withFormat: dayFormat)
            }
            
            return text
            
        case .month:
            return start.string(withFormat: monthFormat)
            
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


extension Int {
    
    /// - Returns: A random integer in the range [min, max] (inclusive).
    static func random(min: Int, max: Int) -> Int {
        return Int(arc4random()) % (max - min + 1) + min
    }
    
}

extension Double {
    
    /// - Returns: A random double in the range [0, 1] (inclusive).
    private static func random0To1() -> Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
    
    /// - Returns: A random double in the range [min, max] (inclusive).
    static func random(min: Double, max: Double) -> Double {
        return random0To1() * (max - min) + min
    }
    
}


extension UIColor {
    
    /// A convenience initializer to use `Double` values without having to convert to `CGFloat`.
    @nonobjc
    convenience init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
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



