//
//  TaskListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController {

    enum Segues: String {
        case showNewTask
    }
    
    // MARK: - Properties
    
    weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    var priority: Priority? {
        didSet {
            print("\(#function): priority received")
        }
    }
    
//    var detailViewController: TaskDetailViewController? = nil
//    
//    /// Stores the time when the back button was pressed,
//    /// not after the user has typed in the task's name
//    var newTaskTimeInterval: TimeInterval?
    
    
    // MARK: - View Management

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the title to match the priority
        title = priority?.name
        
        // Put Add and Edit buttons on the right
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItems = [addButtonItem, editButtonItem]
        
//        // Track the detail view controller
//        if let split = self.splitViewController {
//            let controllers = split.viewControllers
//            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? TaskDetailViewController
//        }
        
//        // Show the primary and secondary view controllers side by side
//        splitViewController?.preferredDisplayMode = .allVisible
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
    }

    func addButtonTapped() {
        print()
        print(#function)
        
        // Go to the new task interface
        performSegue(withIdentifier: "showNewTask", sender: self)
    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print()
        print(#function)
        
        
        // Show new task interface
        if segue.identifier == Segues.showNewTask.rawValue {
            print(Segues.showNewTask.rawValue)
            
            // Update destination
            //(segue.destination as? NewTaskViewController)?.parentMasterViewController = self
        }
        
//        // Show task detail interface
//        else if segue.identifier == "showDetail" {
//            print("showDetail")
//            
//            // Get the selected task
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let task = tasks[indexPath.row]
//                let destination = (segue.destination as? UINavigationController)?.topViewController as? TaskDetailViewController
//                
//                print("Setting DetailViewController task: task = \(task), destination = \(destination)")
//                
//                // Update the destination with the selected task
//                destination?.task = task
//            }
//        }
    }

    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priority?.tasks.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Label the cell
        cell.textLabel?.text = priority?.tasks[indexPath.row].name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        // All items editable
        return true
    }
    
    // Table view edit operations
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete task, update data model
        if editingStyle == .delete {
            priority?.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataModel?.writeToFile()
        }
        
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
    }
    
    
    // MARK: - Task Management
    
    /// Adds a new task, updates the table view and data on disk
    func addTask(name: String) {
        print()
        print(#function)
    }

}

