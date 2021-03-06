//
//  DateIntervalPriorityAnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-28.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

/// A list of tasks for a given date interval and priority.
class DateIntervalPriorityAnalysisViewController: TaskListViewController {

    /// The date interval being analyzed.
    var dateInterval: DateInterval?
    /// The priority being analyzed.
    var priority: Priority?
    /// The length of the date interval, used for string formatting.
    var dateIntervalLength: DateIntervalLength?
    
    override var segueIdentifier: String {
        return "DateIntervalPriorityAnalysis_Task"
    }
    
    
    func setup(tasks: [Task],
               dateInterval: DateInterval,
               priority: Priority,
               dateIntervalLength: DateIntervalLength) {
        super.setup(tasks: tasks)
        
        self.dateInterval = dateInterval
        self.priority = priority
        self.dateIntervalLength = dateIntervalLength
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the view's title to match the length of the date interval and the priority
        if let dateInterval = dateInterval,
                let priority = priority,
                let dateIntervalLength = dateIntervalLength {
            title = "\(priority.name) (\(dateInterval.format(for: dateIntervalLength, stringLength: .short)))"
        }
    }

}

