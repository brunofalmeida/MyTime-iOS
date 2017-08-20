//
//  AllTaskListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

/// A list of all tasks.
class AllTaskListViewController: TaskListViewController {
    
    override var segueIdentifier: String {
        return "AllTask_Task"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(tasks: DataModel.default.allTasks)
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

