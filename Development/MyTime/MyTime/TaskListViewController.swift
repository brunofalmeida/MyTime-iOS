//
//  MasterViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController {

    // MARK: - Properties
    
    var detailViewController: DetailViewController? = nil
    
    /// Stores the time when the back button was pressed, not after the user has typed in the task's name
    var newTaskTimeInterval: TimeInterval?
    
    /// List of tasks
    fileprivate var tasks: [Task] = []
    
    /// URL to documents directory
    fileprivate var documentsURL: URL? {
        //print()
        //print("documentsURL")
        
        // Look for app documents directory
        guard let documentsDirectory = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true).first else {
            print("Couldn't find document directory")
            return nil
        }
        
        // Convert documents directory from a string to a URL
        guard let documentsURL = URL(string: documentsDirectory) else {
            print("Couldn't convert document directory to a URL")
            return nil
        }
        
        return documentsURL
    }
    
    /// The tasks URL, with the output file name appended
    fileprivate var tasksURL: URL? {
        return documentsURL?.appendingPathComponent("Tasks.plist")
    }

    
    // MARK: - View Management

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Enable the button to edit the table cells
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        // Add an add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
        
        // Track the detail view controller
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // Load tasks from file
        tasks = readTasksFromFile() ?? []
        
        // Show the primary and secondary view controllers side by side
        splitViewController?.preferredDisplayMode = .allVisible
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        
        super.viewWillAppear(animated)
    }

    func addButtonTapped() {
        print()
        print("addButtonTapped()")
        
        // Go to the new task interface
        performSegue(withIdentifier: "newTask", sender: self)
    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print()
        print("prepare(for:, sender:)")
        
        // Show task detail interface
        if segue.identifier == "showDetail" {
            print("showDetail")
            
            // Get the selected task
            if let indexPath = tableView.indexPathForSelectedRow {
                let task = tasks[indexPath.row]
                let destination = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController
                
                print("Setting DetailViewController task: task = \(task), destination = \(destination)")
                
                // Update the destination with the selected task
                destination?.task = task
            }
        }
        
        // Show new task interface
        else if segue.identifier == "newTask" {
            print("newTask")
            
            // Update destination
            (segue.destination as? NewTaskViewController)?.parentMasterViewController = self
        }
    }

    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Label the cell with the task name
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.description
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Table view edit operations
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Delete task, rewrite updated tasks to a file
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            writeTasksToFile(tasks: tasks)
        }
        
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
    }
    
    
    // MARK: - Task Management
    
    /// Adds a new task, updates the table view and data on disk
    func addTask(name: String) {
        print()
        print("addTask()")
        
        // Check if a time interval has been stored for the task
        if let timeInterval = newTaskTimeInterval {
            tasks.append(Task(name: name, timeInterval: timeInterval))
            newTaskTimeInterval = nil
            
            tableView.reloadData()
            
            print("Task added")
        } else {
            print("No time interval stored - task not added")
        }
        
        print(tasks as NSArray)
        
        writeTasksToFile(tasks: tasks)
    }
    
    func writeTasksToFile(tasks: [Task]) {
        print()
        print("writeTasksToFile()")
        
        guard let tasksURL = self.tasksURL else {
            print("tasksURL doesn't exist")
            return
        }
        
        print("File: \(tasksURL.path)")
        print("Tasks:")
        print(tasks as NSArray)
        
        if NSKeyedArchiver.archiveRootObject(tasks, toFile: tasksURL.path) {
            print("Write succeeded")
        } else {
            print("Write failed")
        }
        
        print("File existence: \(FileManager.default.fileExists(atPath: tasksURL.path))")
    }
    
    func readTasksFromFile() -> [Task]? {
        print()
        print("readTasksFromFile()")
        
        guard let tasksURL = self.tasksURL else {
            print("tasksURL doesn't exist")
            return nil
        }
        
        print("File: \(tasksURL.path)")
        print("File existence: \(FileManager.default.fileExists(atPath: tasksURL.path))")
        
        if let readTasks = NSKeyedUnarchiver.unarchiveObject(withFile: tasksURL.path) as? NSArray {
            print("Read succeeded")
            print("Read tasks:")
            print(readTasks)
            
            // Convert from NSArray to Swift Array
            if let readTasksSwiftArray = readTasks as? [Task] {
                return readTasksSwiftArray
            } else {
                print("Failed to convert tasks from NSArray to [Task]")
            }
        } else {
            print("Read failed")
        }
        
        return nil
    }

}

