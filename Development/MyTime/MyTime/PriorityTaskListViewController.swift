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

    fileprivate var priority: Priority?
    
    func setup(priority: Priority) {
        super.setup(tasks: priority.tasks)
        
        self.priority = priority
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title to match the priority
        title = priority?.name
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
