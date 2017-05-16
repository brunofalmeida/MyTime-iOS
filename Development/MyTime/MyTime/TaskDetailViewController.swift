//
//  TaskDetailViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class TaskDetailViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // The task to display and edit
    fileprivate var task: Task? {
        didSet {
            print("\(#function): \(String(describing: task))")
        }
    }

    func setup(task: Task?) {
        self.task = task
    }

    /// Update the interface
    fileprivate func configureView() {
        clearsSelectionOnViewWillAppear = true
        
        // Title = task name
        title = task?.name
        
        // Priority
        if let priorityLabel = self.priorityLabel {
            print("priorityLabel exists")
            priorityLabel.text = task?.priority?.description
        } else {
            print("priorityLabel doesn't exist")
        }
        
        // Name
        if let nameTextField = self.nameTextField {
            print("nameTextField exists")
            nameTextField.text = task?.name
        } else {
            print("nameTextField doesn't exist")
        }
        
        // Time
        if let timeLabel = self.timeLabel {
            print("timeLabel exists")
            timeLabel.text = task?.timeSpent.description
        } else {
            print("timeLabel doesn't exist")
        }
        
        // Clear the priority row's highlighted selection
        tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(#file) \(#function)")
        super.viewWillAppear(animated)
        
        configureView()
        
        // If the task detail view was reached from the new task view,
        // remove the new task view because the task is already created
        
        // If there are 2 or more view controllers in the navigation controller
        if let navigationController = navigationController,
                navigationController.viewControllers.count >= 2 {
            print("Navigation stack: \(navigationController.viewControllers)")
            
            // Remove the new task view controller if it exists (2nd last in navigation stack)
            if (navigationController.viewControllers[navigationController.viewControllers.count - 2] is NewTaskViewController) {
                navigationController.viewControllers.remove(at: navigationController.viewControllers.count - 2)
            }
            
            // To verify, print the navigation stack after 1 second since the remove operation doesn't appear immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                print("Navigation stack: \(navigationController.viewControllers)")
            }
            
//            // Might need this later
//            navigationController.popToRootViewController(animated: true)
        }
    }
    
    
    // MARK: - Navigation

    // Prepare before segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PrioritySelectionViewController {
            destination.setup(task: task)
        }
    }

}

/// Delegate for the task name text field
extension TaskDetailViewController: UITextFieldDelegate {
    
    // Be alerted when the text in the field changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)
        
        // Get the modified text
        if let newName: String = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            // Update the model and view title
            task?.name = newName
            title = newName
        }
        
        // Proceed with modifying the text field text
        return true
    }
    
}



