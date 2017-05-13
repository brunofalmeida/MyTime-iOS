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
    
    
    var task: Task? {
        didSet {
            print("\(#function): \(String(describing: task))")
        }
    }

    func setup(task: Task?) {
        self.task = task
    }

    /// Update the interface for the detail item
    func configureView() {
        clearsSelectionOnViewWillAppear = true
        title = task?.name
        
        if let priorityLabel = self.priorityLabel {
            print("priorityLabel exists")
            priorityLabel.text = task?.priority?.description
        } else {
            print("priorityLabel doesn't exist")
        }
        
        if let nameTextField = self.nameTextField {
            print("nameTextField exists")
            nameTextField.text = task?.name
        } else {
            print("nameTextField doesn't exist")
        }
        
        if let timeLabel = self.timeLabel {
            print("timeLabel exists")
            timeLabel.text = task?.timeInterval.description
        } else {
            print("timeLabel doesn't exist")
        }
        
        // Clear the priority row's highlighted selection
        tableView.deselectRow(at: IndexPath(row: 1, section: 0), animated: true)
    }
//    
//    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(#file) \(#function)")
        configureView()
        
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        super.viewWillDisappear(animated)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PrioritySelectionViewController {
            destination.setup(task: task)
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension TaskDetailViewController: UITextFieldDelegate {
    
    // Be alerted when the text in the field changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(#function)
        
        if let newName: String = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            task?.name = newName
            title = newName
        }
        
        return true
    }
    
}



