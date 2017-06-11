//
//  AnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class AnalysisViewController: UITableViewController {
    
    fileprivate weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    var dateIntervals: [DateInterval] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateDateIntervals()
    }
    
    /// Populates `dateIntervals` with weeks containing one or more tasks.
    func populateDateIntervals() {
        if let dataModel = dataModel {
            // Map each task to the date interval of the week of its start time
            let rawDateIntervals = dataModel.allTasks.map { type(of: self).dateInterval(forWeekOf: $0.startTime) }
            
            // Remove duplicates
            dateIntervals = Array<DateInterval>(Set<DateInterval>(rawDateIntervals))
            
            // Sort (most recent first)
            dateIntervals.sort()
            dateIntervals.reverse()
        }
    }
    
    /**
     - Returns: The date interval for the week containing the given date.
     */
    static func dateInterval(forWeekOf date: Date) -> DateInterval {
//        print(#function)
        
        let now = Date()
        var interval = DateInterval()
        
        // Monday 0:00
        var startMatching = DateComponents()
        startMatching.weekday = 2
        startMatching.hour = 0
        startMatching.minute = 0
        startMatching.second = 0
        startMatching.nanosecond = 0
        interval.start = Calendar.current.nextDate(after: date, matching: startMatching, matchingPolicy: .strict, repeatedTimePolicy: .last, direction: .backward) ?? now

        // Sunday 11:59
        var endMatching = DateComponents()
        endMatching.weekday = 1
        endMatching.hour = 23
        endMatching.minute = 59
        endMatching.second = 59
        endMatching.nanosecond = pow(base: 10, exponent: 8) - 1
        interval.end = Calendar.current.nextDate(after: date, matching: endMatching, matchingPolicy: .strict, repeatedTimePolicy: .last, direction: .forward) ?? now
        
//        print("Interval: \(interval)")
        
        return interval
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateIntervals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = type(of: self).format(dateInterval: dateIntervals[indexPath.row])
        return cell
    }
    
    /**
     Formats the date interval to a string with the months and days.
     For example, returns "June 5-11" (if the months are the same)
     or "June 26 - July 2" (if the months are different).
     */
    static func format(dateInterval: DateInterval) -> String {
        // TODO - update to use DateIntervalFormatter?
        
        var text = ""
        
        let start = dateInterval.start
        let end = dateInterval.end
        
        let startFormat = DateFormatter()
        let endFormat = DateFormatter()
        
        // Full month name (MMMM), day with at least 1 digit (d)
        startFormat.dateFormat = "MMMM d"
        text += "\(startFormat.string(from: start))"
        
        if start.components([.month]).month == end.components([.month]).month {
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




extension Date {
    /// Gets date components for the current calendar.
    func components(_ components: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(components, from: self)
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
 A convenience function for taking integer powers without having to cast to Double.
 */
func pow(base: Int, exponent: Int) -> Int {
    return Int( pow(Double(base), Double(exponent)) )
}


// TODO - Utility method to get a specific component from a Date (don't have to duplicate component name)


