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
    
    override func viewWillAppear(_ animated: Bool) {
        if let navigationController = navigationController,
                navigationController.viewControllers.count >= 2 {
            print("Navigation stack: \(navigationController.viewControllers)")
            
            // Remove the new task view controller
            if (navigationController.viewControllers[navigationController.viewControllers.count - 2] is NewTaskViewController) {
                navigationController.viewControllers.remove(at: navigationController.viewControllers.count - 2)
            }
            
            // Print the navigation stack after 1 second since the remove operation doesn't appear immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Navigation stack: \(navigationController.viewControllers)")
            }
            
            // Might need this later
//            navigationController.popToRootViewController(animated: true)
            
        }
    }

}



