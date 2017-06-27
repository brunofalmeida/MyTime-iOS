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
    
    /// The date intervals containing saved tasks, mapped to their corresponding tasks.
    var intervalsToTasks: [DateInterval: [Task]] = [:]
    /// `intervalsToTasks` as a sorted array.
    var intervalsToTasksArray: [(key: DateInterval, value: [Task])] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateIntervalsToTasks()
    }
    
    /// Populates `intervalsToTasks` and `intervalsToTasksArray` with date intervals and the corresponding tasks.
    func populateIntervalsToTasks() {
//        print(#function)
        
        intervalsToTasks = [:]
        
        if let dataModel = dataModel {
            // For each task saved
            for task in dataModel.allTasks {
                // Get the date interval for the week containing this task
                let interval = task.startTime.dateIntervalForWeek()
                
                // Check whether the date interval is already stored, and add the task appropriately
                if intervalsToTasks.keys.contains(interval) {
                    intervalsToTasks[interval]?.append(task)
                } else {
                    intervalsToTasks[interval] = [task]
                }
            }
        }
        
        // Convert the dictionary to a sorted array (most recent date interval first)
        intervalsToTasksArray = Array(intervalsToTasks).sorted(by: { $0.key > $1.key })
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DateIntervalAnalysisViewController,
                let row = tableView.indexPathForSelectedRow?.row {
            destination.setup(dateInterval: intervalsToTasksArray[row].key, tasks: intervalsToTasksArray[row].value, dateIntervalLength: .week)
        }
    }
 
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intervalsToTasksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = intervalsToTasksArray[indexPath.row].key.formatForWeek
        return cell
    }

}



