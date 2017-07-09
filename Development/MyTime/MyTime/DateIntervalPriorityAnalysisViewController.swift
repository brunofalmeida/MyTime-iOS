//
//  DateIntervalPriorityAnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-28.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class DateIntervalPriorityAnalysisViewController: TaskListViewController {

    /// The date interval being analyzed.
    var dateInterval: DateInterval?
    /// The priority being analyzed.
    var priority: Priority?
    /// The length of the date interval, used for string formatting.
    var dateIntervalLength: DateIntervalAnalysisViewController.DateIntervalLength?
    
    
    func setup(tasks: [Task],
               dateInterval: DateInterval,
               priority: Priority,
               dateIntervalLength: DateIntervalAnalysisViewController.DateIntervalLength) {
        super.setup(tasks: tasks)
        
        self.dateInterval = dateInterval
        self.priority = priority
        self.dateIntervalLength = dateIntervalLength
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segueIdentifier = "DateIntervalPriorityAnalysis_Task"

        // Set up the view's title to match the length of the date interval and the priority
        if let dateInterval = dateInterval,
                let priority = priority,
                let dateIntervalLength = dateIntervalLength {
            if dateIntervalLength == .week {
                title = "\(dateInterval.format(for: .week)) (\(priority.name))"
            }
        }
    }

}

