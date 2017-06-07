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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var timeSpentLabel: UILabel!
    
    // The task to display and edit
    fileprivate var task: Task? {
        didSet {
//            print("\(#function): \(String(describing: task))")
        }
    }

    func setup(task: Task?) {
        self.task = task
    }

    /// Updates the interface
    fileprivate func configureView() {
        clearsSelectionOnViewWillAppear = true
        
        // Title - task name
        if let task = task {
            title = task.name
        } else {
            assertionFailure()
        }
        
        // Table view
        configureGeneralTableSection()
        configureDateAndTimeTableSection()
    
        // Clear the priority row's highlighted selection
        tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
    }
    
    fileprivate func configureGeneralTableSection() {
        if let task = task {
            // Name
            if let nameTextField = self.nameTextField {
                nameTextField.text = task.name
            } else {
                assertionFailure()
            }
            
            // Priority
            if let priorityLabel = self.priorityLabel {
                priorityLabel.text = task.priority?.description
            } else {
                assertionFailure()
            }
        }
        
        else {
            assertionFailure()
        }
    }
    
    fileprivate func configureDateAndTimeTableSection() {
        // Date and time formatting
        // http://www.codingexplorer.com/swiftly-getting-human-readable-date-nsdateformatter/
        
        // Date format - Full day name, full month name, day with at least 1 digit
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE, MMMM d"
        
        // Time format - Hour, minute, AM/PM
        let timeFormat = DateFormatter()
        timeFormat.timeStyle = .short
        
        
        if let task = task {
            // Date
            if let dateLabel = self.dateLabel {
                dateLabel.text = dateFormat.string(from: task.startTime)
            } else {
                assertionFailure()
            }
            
            // Start time
            if let startTimeLabel = self.startTimeLabel {
                startTimeLabel.text = timeFormat.string(from: task.startTime)
            } else {
                assertionFailure()
            }
            
            // End time
            if let endTimeLabel = self.endTimeLabel {
                endTimeLabel.text = timeFormat.string(from: task.endTime)
            } else {
                assertionFailure()
            }
            
            // Time spent
            if let timeSpentLabel = self.timeSpentLabel {
                timeSpentLabel.text = task.timeSpent.listDescription
            } else {
                assertionFailure()
            }
        }
        
        else {
            assertionFailure()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print(#function)
        super.viewWillAppear(animated)
        
        configureView()
        
        // If the task detail view was reached from the new task view,
        // remove the new task view because the task is already created
        
        // If there are 2 or more view controllers in the navigation controller
        if let navigationController = navigationController,
                navigationController.viewControllers.count >= 2 {
//            print("Navigation stack: \(navigationController.viewControllers)")
            
            // Remove the new task view controller if it exists (2nd last in navigation stack)
            if (navigationController.viewControllers[navigationController.viewControllers.count - 2] is NewTaskViewController) {
                navigationController.viewControllers.remove(at: navigationController.viewControllers.count - 2)
            }
            
            // To verify, print the navigation stack after 1 second since the remove operation doesn't appear immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                print("Navigation stack: \(navigationController.viewControllers)")
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



