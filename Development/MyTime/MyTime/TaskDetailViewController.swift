//
//  TaskDetailViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class TaskDetailViewController: UITableViewController {
    
    @IBOutlet weak var priorityTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    
    
    var priority: Priority? {
        didSet {
            print("\(#function) \(String(describing: priority))")
        }
    }
    var task: Task? {
        didSet {
            print("\(#function): \(String(describing: task))")
        }
    }

    func setup(priority: Priority, task: Task) {
        self.priority = priority
        self.task = task
    }

    /// Update the interface for the detail item
    func configureView() {
        if let priorityTextField = self.priorityTextField {
            print("priorityTextField exists")
            priorityTextField.text = priority?.description
        } else {
            print("priorityTextField doesn't exist")
        }
        
        if let nameTextField = self.nameTextField {
            print("nameTextField exists")
            nameTextField.text = task?.name
        } else {
            print("nameTextField doesn't exist")
        }
        
        if let timeTextField = self.timeTextField {
            print("timeTextField exists")
            timeTextField.text = task?.timeInterval.description
        } else {
            print("timeTextField doesn't exist")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureView()
    }

}



