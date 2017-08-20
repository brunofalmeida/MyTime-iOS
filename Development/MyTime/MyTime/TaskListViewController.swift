//
//  TaskListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

/// A generic list of tasks.
class TaskListViewController: UITableViewController {
    
    /// The storyboard cell reuse identifier and .xib file name for the table view cell.
    let cellIdentifier: String = "ThreeLabelCell"
    
    /**
     The storyboard identifier of the segue to TaskDetailViewController.
     Must be overriden for each unique segue.
     */
    var segueIdentifier: String {
        assertionFailure()
        return "FIXME"
    }
    
    /// The list of tasks to display
    fileprivate var tasks: [Task] = []
    
    func setup(tasks: [Task]) {
        self.tasks = tasks
    }
    
    
    // MARK: - View Management

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the custom cell so it can be used in the table
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                           forCellReuseIdentifier: cellIdentifier)
        
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
        
        clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
        print(clearsSelectionOnViewWillAppear)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasks.sort { $0.startTime > $1.startTime }
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        DataModel.default.writeToFile()
    }

    
    // MARK: - Table View

    // Number of rows
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    // Cell creation
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath) as! ThreeLabelCell
        
        let task = tasks[indexPath.row]
        
        cell.primaryLabel?.text = task.name
        cell.secondaryLabel?.text = task.startTime.string(withStringLength: .short)
        cell.detailLabel?.text = task.timeSpent.listDescription
        
        return cell
    }
    
    // Editing
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        // Delete task, update data model
        if editingStyle == .delete {
            tasks[row].removeFromPriority()
            tasks.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Cell selection
    // Must manually perform the segue because it is a custom cell.
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print(#function)
        
        super.prepare(for: segue, sender: sender)
        
        // Task detail
        if let destination = segue.destination as? TaskDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            destination.setup(task: tasks[indexPath.row])
        }
    }

}



