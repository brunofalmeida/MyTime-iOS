//
//  MasterViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    /// Stores the time when the back button was pressed, not after the user has typed in the task's name
    var latestTaskTime: Int?
    fileprivate var tasks: [(name: String, time: Int)] = []


    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    func addButtonTapped() {
        print()
        print("addButtonTapped()")
        
        performSegue(withIdentifier: "newTask", sender: self)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print()
        print("prepare(for:, sender:)")
        
        if segue.identifier == "showDetail" {
            print("showDetail")
        } else if segue.identifier == "newTask" {
            print("newTask")
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

        let task = tasks[indexPath.row]
        cell.textLabel?.text = "\(task.name) (\(NewTaskViewController.formatTime(seconds: task.time)))"
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    /**
     Stores a task's time so it is accurate.
     */
    func addTaskTime(timeInSeconds: Int) {
        print()
        print("addTaskTime()")
        
        latestTaskTime = timeInSeconds
        print(latestTaskTime as Any)
    }
    
    func addTaskName(name: String) {
        print()
        print("addTaskName()")
        
        if let time = latestTaskTime {
            tasks.append((name, time))
            latestTaskTime = nil
            tableView.reloadData()
            
            print("Task added")
        } else {
            print("No time stored - task not added")
        }
        
        print(tasks)
    }

}

