//
//  TaskDetailViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

/// A view of a task's details and properties, most of which can be edited.
class TaskDetailViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priorityTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    
    @IBOutlet weak var timeSpentLabel: UILabel!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    
    // The task to display and edit
    fileprivate var task: Task?

    
    
    
    func setup(task: Task?) {
        self.task = task
    }
    
    
    // MARK: - View Management

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
        }
        
        let priorityPicker = UIPickerView()
        priorityPicker.dataSource = self
        priorityPicker.delegate = self
        if let priority = task?.priority, let index = DataModel.default.priorities.index(of: priority) {
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
        configureTimeSpentTableSection()
        configureNotesTableSection()
    
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
        if let task = task {
            // Date
            if let dateTextField = self.dateTextField {
                dateTextField.text = task.startTime.string(withStringLength: .short)
            } else {
                assertionFailure()
            }
            
            // Start time
            if let startTextField = self.startTextField {
                startTextField.text = task.startTime.format(withTimeStyle: DateFormatter.Style.short)
            } else {
                assertionFailure()
            }
            
            // End time
            if let endTextField = self.endTextField {
                endTextField.text = task.endTime.format(withTimeStyle: DateFormatter.Style.short)
            } else {
                assertionFailure()
            }
        }
        
        else {
            assertionFailure()
        }
    }
    
    fileprivate func configureTimeSpentTableSection() {
        if let task = task {
            // Time spent
            if let timeSpentLabel = self.timeSpentLabel {
                timeSpentLabel.text = task.timeSpent.listDescription
            } else {
                assertionFailure()
            }
        }
    }
    
    fileprivate func configureNotesTableSection() {
        if let task = task {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        super.viewWillDisappear(animated)
        
        DataModel.default.writeToFile()
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
    }

}


// MARK: - Text Input Views

/// Delegate for the name text field
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
        
        // Proceed with modifying the text field text
        return true
    }
    
}

/// Delegate for the notes text view
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


// MARK: - Picker Views

extension TaskDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        print(#function)
        return 1
    }
    
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
//        print(#function)
        return DataModel.default.priorities.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
                    forComponent component: Int) -> String? {
//        print(#function)
        return DataModel.default.priorities[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
                    inComponent component: Int) {
        print(#function)
        
        if let task = task {
            task.removeFromPriority()
            task.addToPriority(priority: DataModel.default.priorities[row])
        }
        
        configureGeneralTableSection()
    }
    
}



