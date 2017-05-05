//
//  PrioritySelectionViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-05-03.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class PrioritySelectionViewController: UITableViewController {

    weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    var task: Task?
    var selectedIndexPath: IndexPath?
    
    
    func setup(task: Task?) {
        self.task = task
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        if let dataModel = dataModel, let task = task, let priority = task.priority, let index = dataModel.priorities.index(of: priority) {
            //tableView.selectRow(at: rowSelected, animated: true, scrollPosition: .top)
            tableView(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
        } else {
            assertionFailure()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.priorities.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = dataModel?.priorities[indexPath.row].name

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        
        if let selectedIndexPath = selectedIndexPath {
            tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if let selectedIndexPath = selectedIndexPath, indexPath != selectedIndexPath {
            if let task = task {
                dataModel?.priorities[selectedIndexPath.row].removeTask(task)
                dataModel?.priorities[indexPath.row].addTask(task)
                dataModel?.writeToFile()
            } else {
                assertionFailure("Task not available")
            }
        }
        
        selectedIndexPath = indexPath
    }
    
//    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print(#function)
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        
//        if let task = task {
//            dataModel?.priorities[indexPath.row].removeTask(task)
//            dataModel?.writeToFile()
//        } else {
//            assertionFailure("Task not available")
//        }
//    }
    
    // TODO - make the selection update the task's priority in the data model
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
