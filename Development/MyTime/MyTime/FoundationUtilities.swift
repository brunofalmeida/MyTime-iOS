//
//  FoundationUtilities.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-08-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation


extension Date {
    
    // Time unit conversions
    static let secondsPerMinute: Double = 60
    static let minutesPerHour: Double = 60
    static let hoursPerDay: Double = 24
    
    static let secondsPerDay: Foundation.TimeInterval = Date.secondsPerMinute * Date.minutesPerHour * Date.hoursPerDay
    
    /// Gets a set of specific date components for the current calendar.
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(components, from: self)
    }
    
    /// Gets a specific date component for the current calendar.
    func component(_ component: Calendar.Component) -> Int? {
        return self.components([component]).value(for: component)
    }
    
    /**
     Formats the date according to the given format string,
     without having to create a `DateFormatter` object.
     */
    func format(withString format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /**
     Formats the date according to the given date and time styles,
     without having to create a `DateFormatter` object.
     */
    func format(withDateStyle dateStyle: DateFormatter.Style = .none,
                withTimeStyle timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
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



