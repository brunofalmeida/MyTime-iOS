//
//  DateIntervalAnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-18.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

/// Displays the priorities with tasks in the given date interval.
class DateIntervalAnalysisViewController: UITableViewController {
    
    /// The date interval being examined for time analysis.
    var dateInterval: DateInterval?
    /// The tasks that occurred in the date interval.
    var tasks: [Task] = []
    /// The length of the date interval, used for string formatting.
    var dateIntervalLength: DateIntervalLength?
    
    /// Priorities mapped to their tasks that occured in the date interval.
    var prioritiesToTasks: [Priority: [Task]] = [:]
    /// `prioritiesToTasks` as a sorted array.
    var prioritiesToTasksArray: [(key: Priority, value: [Task])] = []
    
    
    
    
    func setup(dateInterval: DateInterval,
               tasks: [Task],
               dateIntervalLength: DateIntervalLength) {
        self.dateInterval = dateInterval
        self.tasks = tasks
        self.dateIntervalLength = dateIntervalLength
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set up the view's title to match the length of the date interval examined
        if let dateInterval = dateInterval, let dateIntervalLength = dateIntervalLength {
            title = dateInterval.format(for: dateIntervalLength, stringLength: .long)
        }
        
        populatePrioritiesToTasks()
    }
    
    /// Populates `prioritiesToTasks` and `prioritiesToTasksArray`.
    func populatePrioritiesToTasks() {
        prioritiesToTasks = [:]
        
        // For each task
        for task in tasks {
            if let priority = task.priority {
                // Check if the priority is already stored, and add the task appropriately
                if prioritiesToTasks.keys.contains(priority) {
                    prioritiesToTasks[priority]?.append(task)
                } else {
                    prioritiesToTasks[priority] = [task]
                }
            }
        }
        
        // Convert the dictionary to an array, sorted in descending order of the total time spent on tasks
        prioritiesToTasksArray = Array(prioritiesToTasks).sorted(by: { $0.value.totalTimeSpent > $1.value.totalTimeSpent })
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return prioritiesToTasksArray.count
    }

    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = prioritiesToTasksArray[indexPath.row].key.name
        cell.detailTextLabel?.text =
            prioritiesToTasksArray[indexPath.row].value.totalTimeSpent.listDescription
    
        return cell
    }
    
 

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? DateIntervalPriorityAnalysisViewController,
                let row = tableView.indexPathForSelectedRow?.row,
                let dateInterval = dateInterval,
                let dateIntervalLength = dateIntervalLength {
            
            destination.setup(tasks: prioritiesToTasksArray[row].value,
                              dateInterval: dateInterval,
                              priority: prioritiesToTasksArray[row].key,
                              dateIntervalLength: dateIntervalLength)
        }
        
        else if let destination = segue.destination as? GraphAnalysisViewController,
                let dateInterval = dateInterval,
                let dateIntervalLength = dateIntervalLength {
            
            setBackButtonTitleAsBack()
            
            var prioritiesToTimeIntervals: [Priority: TimeInterval] = [:]
            for (key, value) in prioritiesToTasks {
                prioritiesToTimeIntervals[key] = value.totalTimeSpent
            }
            
            destination.setup(dateInterval: dateInterval, dateIntervalLength: dateIntervalLength, prioritiesToTimeIntervals: prioritiesToTimeIntervals)
        }
    }
 
}



