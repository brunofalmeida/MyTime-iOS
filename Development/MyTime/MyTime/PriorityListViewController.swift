//
//  PriorityListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class PriorityListViewController: UITableViewController {

    fileprivate weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    
    override func viewDidLoad() {
//        print(#function)
        super.viewDidLoad()
        
        print("dataModel: \(dataModel as Any)")

        // Edit button in top left
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Add button in top right
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButtonItem
        
        // Clear row selection on apperance
        clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print(#function)
        super.viewWillDisappear(animated)
        
        // Save data
        dataModel?.writeToFile()
    }
    
    /**
     Add button event handler
     
     Prompts the user to create a new priority
     */
    func addButtonTapped() {
        print(#function)
        
        // Create an alert
        let nameAlert = UIAlertController(title: "New Priority", message: nil, preferredStyle: .alert)
        nameAlert.addTextField(configurationHandler: nil)
        
        nameAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        nameAlert.addAction(UIAlertAction(title: "OK", style: .default) { alertAction in
            self.dataModel?.priorities.append(Priority(name: nameAlert.textFields?[0].text ?? DataModel.defaultPriorityName))
            self.tableView.reloadData()
            
            print(self.dataModel as Any)
        })
        
        // Present the alert
        present(nameAlert, animated: true, completion: nil)
    }

    
    // MARK: - Table view data source

    // Number of rows = number of priorities
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.priorities.count ?? 0
    }

    // Cell creation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataModel?.priorities[indexPath.row].name
        return cell
    }
    
    // Support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Delete the row from the data source
        if editingStyle == .delete {
            dataModel?.priorities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dataModel?.writeToFile()
            
            debugPrint(dataModel as Any)
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    
    // Allow all rows to be deleted except the first row (default priority)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if dataModel?.priorities[indexPath.row].name == DataModel.defaultPriorityName {
            return .none
        } else {
            return .delete
        }
    }

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

    
    
    // MARK: - Navigation

    // Preparate for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TaskListViewController,
                let indexPath = tableView.indexPathForSelectedRow {
            destination.setup(priority: dataModel?.priorities[indexPath.row])
        }
    }

}



