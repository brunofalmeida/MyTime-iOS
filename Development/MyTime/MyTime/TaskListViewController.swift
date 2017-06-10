//
//  TaskListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class TaskListViewController: UITableViewController {

    fileprivate enum Segues: String {
        case showNewTask
        case showTaskDetail
    }
    
    // MARK: - Properties
    
    fileprivate weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    fileprivate var priority: Priority? {
        didSet {
//            print("\(#function): priority received")
        }
    }
    
    
    func setup(priority: Priority?) {
        self.priority = priority
    }
    
    // MARK: - View Management

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title to match the priority
        title = priority?.name
        
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
            destination.setup(task: priority?.tasks[indexPath.row])
        }
    }

    
    // MARK: - Table View

    // Number of rows = number of priorities
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        
        return priority?.tasks.count ?? 0
    }

    // Cell creation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = priority?.tasks[indexPath.row].name
        return cell
    }
    
    // Table view editing
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        super.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
        
        // Delete task, update data model
        if editingStyle == .delete {
            priority?.removeTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataModel?.writeToFile()
        }
    }

}



