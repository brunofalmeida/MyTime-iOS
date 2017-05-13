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
            print("\(#function): priority received")
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
        
        // Edit and Add buttons in the top right
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
        tableView.reloadData()
    }

    /**
     Add button event handler
     Segues to the new task interface
     */
    func addButtonTapped() {
        print(#function)
        
        performSegue(withIdentifier: Segues.showNewTask.rawValue, sender: self)
    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        
        // Task detail
        if let destination = segue.destination as? TaskDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
            destination.setup(task: priority?.tasks[indexPath.row])
        }
    }

    
    // MARK: - Table View

    // Number of rows = number of priorities
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priority?.tasks.count ?? 0
    }

    // Cell creation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = priority?.tasks[indexPath.row].name
        return cell
    }
    
    // Table view editing
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        // Delete task, update data model
        if editingStyle == .delete {
            priority?.removeTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataModel?.writeToFile()
        }
    }

}



