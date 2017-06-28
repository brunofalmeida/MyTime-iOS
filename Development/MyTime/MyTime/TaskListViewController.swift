//
//  TaskListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

/**
 A generic view of a list of tasks.
 */
class TaskListViewController: UITableViewController {

    fileprivate enum Segues: String {
        case showNewTask
        case showTaskDetail
    }
    
    // MARK: - Properties
    
    fileprivate weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    /// The list of tasks to display
    fileprivate var tasks: [Task] = []
    
    func setup(tasks: [Task]) {
        self.tasks = tasks
    }
    
    // MARK: - View Management

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default title
//        title = "Tasks"
        
        // Edit button - top right
        navigationItem.rightBarButtonItem = editButtonItem
        
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
        tableView.reloadData()
    }

    
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
//        print(#function)
        
        // Task detail
        if let destination = segue.destination as? TaskDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
            destination.setup(task: tasks[indexPath.row])
        }
    }

    
    // MARK: - Table View

    // Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        
        return tasks.count
    }

    // Cell creation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].name
        cell.detailTextLabel?.text = tasks[indexPath.row].timeSpent.listDescription
        
        return cell
    }
    
    // Table view editing
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        // Delete task, update data model
        if editingStyle == .delete {
            tasks[row].removeFromPriority()
            tasks.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataModel?.writeToFile()
        }
    }

}



