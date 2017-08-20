//
//  PriorityListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class PriorityListViewController: UITableViewController {    
    
    override func viewDidLoad() {
//        print(#function)
        super.viewDidLoad()
        
        print("dataModel: \(DataModel.default)")
        
        // Edit, Add button in top right
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                            target: self,
                                            action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.rightBarButtonItems = [addButtonItem, editButtonItem]
        
        // Clear row selection on apperance
        clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print(#function)
        super.viewWillDisappear(animated)
        
        DataModel.default.writeToFile()
    }
    
    /**
     Add button event handler
     Prompts the user to create a new priority
     */
    func addButtonTapped() {
        print(#function)
        
        // Create an alert
        let nameAlert = UIAlertController(title: "New Priority",
                                          message: nil,
                                          preferredStyle: .alert)
        nameAlert.addTextField(configurationHandler: nil)
        
        nameAlert.addAction(UIAlertAction(title: "Cancel",
                                          style: .default,
                                          handler: nil))
        nameAlert.addAction(UIAlertAction(title: "OK", style: .default) { alertAction in
            DataModel.default.priorities.append(Priority(
                name: nameAlert.textFields?[0].text ?? DataModel.defaultPriorityName))
            self.tableView.reloadData()
            
            print(DataModel.default)
        })
        
        // Present the alert
        present(nameAlert, animated: true, completion: nil)
    }

    
    // MARK: - Table view data source

    // Number of rows = number of priorities
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return DataModel.default.priorities.count
    }

    // Cell creation
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = DataModel.default.priorities[indexPath.row].name
        return cell
    }
    
    // Support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        // Delete the row from the data source
        if editingStyle == .delete {
            DataModel.default.priorities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            debugPrint(DataModel.default)
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
    }
    
    // Allow all rows to be deleted except the first row (default priority)
    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if DataModel.default.priorities[indexPath.row].name == DataModel.defaultPriorityName {
            return .none
        } else {
            return .delete
        }
    }

    
    // MARK: - Navigation

    // Preparate for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PriorityTaskListViewController,
                let indexPath = tableView.indexPathForSelectedRow {
            destination.setup(priority: DataModel.default.priorities[indexPath.row])
        }
    }

}



