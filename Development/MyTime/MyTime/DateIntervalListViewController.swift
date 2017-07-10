//
//  DateIntervalListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class DateIntervalListViewController: UITableViewController {
    
    fileprivate weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    var dateIntervalLength: DateIntervalAnalysisViewController.DateIntervalLength?
    /// The date intervals containing saved tasks, mapped to their corresponding tasks.
    var intervalsToTasks: [DateInterval: [Task]] = [:]
    /// `intervalsToTasks` as a sorted array.
    var intervalsToTasksArray: [(key: DateInterval, value: [Task])] = []
    
    
    
    
    func setup(dateIntervalLength: DateIntervalAnalysisViewController.DateIntervalLength) {
        self.dateIntervalLength = dateIntervalLength
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dateIntervalLength = dateIntervalLength {
            title = "\(dateIntervalLength.adjective) Analysis"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateIntervalsToTasks()
    }
    
    /// Populates `intervalsToTasks` and `intervalsToTasksArray`.
    func populateIntervalsToTasks() {
//        print(#function)
        
        intervalsToTasks = [:]
        
        if let dataModel = dataModel, let dateIntervalLength = dateIntervalLength {
            
            // For each task saved
            for task in dataModel.allTasks {
                
                // Get the appropriate date interval containing this task
                let interval = task.startTime.dateInterval(for: dateIntervalLength)
                
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
                let row = tableView.indexPathForSelectedRow?.row,
                let dateIntervalLength = dateIntervalLength {
            destination.setup(dateInterval: intervalsToTasksArray[row].key,
                              tasks: intervalsToTasksArray[row].value,
                              dateIntervalLength: dateIntervalLength)
        }
    }
 
    // Number of rows
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return intervalsToTasksArray.count
    }
    
    // Cell creation
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let dateIntervalLength = dateIntervalLength {
            cell.textLabel?.text =
                intervalsToTasksArray[indexPath.row].key.format(for: dateIntervalLength)
        }
        cell.detailTextLabel?.text =
            intervalsToTasksArray[indexPath.row].value.totalTimeSpent.listDescription
        
        return cell
    }

}


