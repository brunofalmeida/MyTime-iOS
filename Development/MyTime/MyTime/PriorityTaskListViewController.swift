//
//  PriorityTaskListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

/**
 A list of tasks for a specific priority.
 */
class PriorityTaskListViewController: TaskListViewController {

    /// The priority to display tasks for.
    fileprivate var priority: Priority?
    
    func setup(priority: Priority) {
        self.priority = priority
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segueIdentifier = "PriorityTaskList_Task"
        
        // Set the title to match the priority
        title = priority?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let priority = priority {
            super.setup(tasks: priority.tasks)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

