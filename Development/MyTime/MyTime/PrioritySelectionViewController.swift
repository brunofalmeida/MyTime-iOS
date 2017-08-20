//
//  PrioritySelectionViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-05-03.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class PrioritySelectionViewController: UITableViewController {
    
    /// The task whose priority is being selected
    fileprivate var task: Task?
    
    /// The previously selected row
    fileprivate var selectedIndexPath: IndexPath?
    
    
    func setup(task: Task?) {
        self.task = task
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        // Select the task's existing priority
        if let task = task,
                let priority = task.priority,
                let index = DataModel.default.priorities.index(of: priority) {
            tableView(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
        } else {
            assertionFailure()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DataModel.default.writeToFile()
    }
    

    // MARK: - Table view data source

    // Number of rows = number of priorities
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return DataModel.default.priorities.count
    }

    // Cell creation
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = DataModel.default.priorities[indexPath.row].name
        return cell
    }
 
    // Row selection
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
//        print(#function)
        
        // If a row was previously selected, deselect it
        if let selectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        }
        
        // Select the chosen row
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        // If the row selected is not being reselected (was not the previous row selected)
        if let selectedIndexPath = selectedIndexPath,
                indexPath != selectedIndexPath {
            if let task = task {
                // Delete the task from the previous priority, add it to the new priority
                DataModel.default.priorities[selectedIndexPath.row].removeTask(task)
                DataModel.default.priorities[indexPath.row].addTask(task)
            } else {
                assertionFailure("Task not available")
            }
        }
        
        // Update the previously selected row to the current one
        selectedIndexPath = indexPath
    }

}



