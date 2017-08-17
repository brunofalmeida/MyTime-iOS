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
    @IBOutlet weak var priorityTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var timeSpentLabel: UILabel!
    
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    
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
        configureDetailsTableSection()
    
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
            if let priorityTextField = self.priorityTextField {
                priorityTextField.text = task.priority?.description
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
        
        if let task = task {
            // Date
            if let dateTextField = self.dateTextField {
                dateTextField.text = task.startTime.string(withStringLength: .short)
            } else {
                assertionFailure()
            }
            
            // Start time
            if let startTextField = self.startTextField {
                startTextField.text = task.startTime.string(withTimeStyle: DateFormatter.Style.short)
            } else {
                assertionFailure()
            }
            
            // End time
            if let endTextField = self.endTextField {
                endTextField.text = task.endTime.string(withTimeStyle: DateFormatter.Style.short)
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
    
    fileprivate func configureDetailsTableSection() {
        if let task = task {
            // Name
            if let taskDescriptionTextField = self.taskDescriptionTextField {
                taskDescriptionTextField.text = task.taskDescription
            } else {
                assertionFailure()
            }
            
            // Priority
            if let notesTextView = self.notesTextView {
                notesTextView.text = task.notes
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
        
        let priorityPicker = UIPickerView()
        priorityPicker.dataSource = self
        priorityPicker.delegate = self
        if let priority = task?.priority, let index = dataModel?.priorities.index(of: priority) {
            priorityPicker.selectRow(index, inComponent: 0, animated: true)
        }
        priorityTextField.inputView = priorityPicker
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        super.viewWillDisappear(animated)
        
        dataModel?.writeToFile()
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
                print(task)
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
        
        if textField == nameTextField {
            // Get the modified text
            if let newName: String = (textField.text as NSString?)?
                    .replacingCharacters(in: range, with: string) {
                // Update the model and view title
                task?.name = newName
                title = newName
            }
        }
        
        else if (textField == taskDescriptionTextField) {
            if let task = task {
                task.taskDescription = (task.taskDescription as NSString).replacingCharacters(in: range, with: string)
            }
        }
        
        // Proceed with modifying the text field text
        return true
    }
    
}

extension TaskDetailViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        print(#function)
        
        if let task = task {
            task.notes = (task.notes as NSString)
                .replacingCharacters(in: range, with: text)
        }
        
        // Proceed with modifying the text field text
        return true
    }
    
}



extension TaskDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print(#function)
        return 1
    }
    
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(#function)
        return dataModel?.priorities.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print(#function)
        return dataModel?.priorities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(#function)
        
        if let task = task {
            task.removeFromPriority()
            
            if let priority = dataModel?.priorities[row] {
                task.addToPriority(priority: priority)
            }
        }
        
        configureGeneralTableSection()
    }
    
}



