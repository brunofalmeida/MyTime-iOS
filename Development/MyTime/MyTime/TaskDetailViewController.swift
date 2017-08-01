//
//  TaskDetailViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class TaskDetailViewController: UITableViewController {
    
    fileprivate weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
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
        let dateFormat = "EEEE, MMMM d"
        
        // Time format - Hour, minute, AM/PM
        let timeStyle = DateFormatter.Style.short
        
        if let task = task {
            // Date
            if let dateTextField = self.dateTextField {
                dateTextField.text = task.startTime.string(withFormat: dateFormat)
            } else {
                assertionFailure()
            }
            
            // Start time
            if let startTextField = self.startTextField {
                startTextField.text = task.startTime.string(withTimeStyle: timeStyle)
            } else {
                assertionFailure()
            }
            
            // End time
            if let endTextField = self.endTextField {
                endTextField.text = task.endTime.string(withTimeStyle: timeStyle)
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
            if (navigationController.viewControllers[navigationController.viewControllers.count - 2]
                    is NewTaskTimerViewController) {
                navigationController.viewControllers.remove(
                    at: navigationController.viewControllers.count - 2)
            }
            
            // To verify, print the navigation stack after 1 second
            // since the remove operation doesn't appear immediately
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                print("Navigation stack: \(navigationController.viewControllers)")
            }
            
//            // Might need this later
//            navigationController.popToRootViewController(animated: true)
        }
        
        let datePicker = UIDatePicker()
        let startPicker = UIDatePicker()
        let endPicker = UIDatePicker()
        
        datePicker.datePickerMode = .date
        startPicker.datePickerMode = .time
        endPicker.datePickerMode = .time
        
        if let task = task {
            datePicker.date = task.startTime
            startPicker.date = task.startTime
            endPicker.date = task.endTime
        }
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        startPicker.addTarget(self, action: #selector(startPickerValueChanged), for: .valueChanged)
        endPicker.addTarget(self, action: #selector(endPickerValueChanged), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        startTextField.inputView = startPicker
        endTextField.inputView = endPicker
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        print("Date changed: \(sender.date)")
        
        if let task = task {
            // Get the date components from the picker
            var startComponents = sender.date.components([.calendar, .year, .month, .day])
            
            // Get the time components from the existing start time
            startComponents.setValue(task.startTime.component(.hour), for: .hour)
            startComponents.setValue(task.startTime.component(.minute), for: .minute)
            startComponents.setValue(task.startTime.component(.second), for: .second)
            
            if let startDate = startComponents.date {
                task.startTime = startDate
            } else {
                assertionFailure("Could not create a date from the components")
            }
        } else {
            assertionFailure()
        }
        
        configureDateAndTimeTableSection()
        dataModel?.writeToFile()
    }
    
    func startPickerValueChanged(sender: UIDatePicker) {
        print("Start changed: \(sender.date)")
        
        if let task = task {
            // Get the time components from the picker
            var startComponents = sender.date.components([.calendar, .hour, .minute, .second])
            
            // Get the date components from the existing start time
            startComponents.setValue(task.startTime.component(.year), for: .year)
            startComponents.setValue(task.startTime.component(.month), for: .month)
            startComponents.setValue(task.startTime.component(.day), for: .day)
            startComponents.setValue(0, for: .nanosecond)
            
            if let startDate = startComponents.date {
                task.startTime = startDate
            } else {
                assertionFailure("Could not create a date from the components")
            }
        } else {
            assertionFailure()
        }
        
        configureDateAndTimeTableSection()
        dataModel?.writeToFile()
    }
    
    func endPickerValueChanged(sender: UIDatePicker) {
        print("End changed: \(sender.date)")
        
        if let task = task {
            // Get the time components from the picker
            var endComponents = sender.date.components([.calendar, .hour, .minute, .second])
            
            // Get the date components from the existing start time
            endComponents.setValue(task.startTime.component(.year), for: .year)
            endComponents.setValue(task.startTime.component(.month), for: .month)
            endComponents.setValue(task.startTime.component(.day), for: .day)
            
            if let endDate = endComponents.date {
                task.endTime = endDate
            } else {
                assertionFailure("Could not create a date from the components")
            }
        } else {
            assertionFailure()
        }
        
        configureDateAndTimeTableSection()
        dataModel?.writeToFile()
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
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        print(#function)
        
        // Get the modified text
        if let newName: String = (textField.text as NSString?)?
                .replacingCharacters(in: range, with: string) {
            // Update the model and view title
            task?.name = newName
            title = newName
        }
        
        // Proceed with modifying the text field text
        return true
    }
    
}



