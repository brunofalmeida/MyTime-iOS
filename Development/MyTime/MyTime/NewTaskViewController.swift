//
//  NewTaskViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

/// Allows the user to select how to create a new task.
class NewTaskViewController: UITableViewController {

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TaskDetailViewController {
            
            // Create a new task - default priority and name, start and end time are now
            let priority = DataModel.default.defaultPriority
            let task = Task(name: DataModel.defaultTaskName,
                            startTime: Date(),
                            endTime: Date())
            priority?.addTask(task)
            
            destination.setup(task: task)
        }
    }
 
}

