//
//  PriorityListViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class PriorityListViewController: UITableViewController {

    weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        
        print("dataModel:")
        debugPrint(dataModel as Any)

        // Display an Edit button in the navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        super.viewWillDisappear(animated)
        
        dataModel?.writeToFile()
    }
    
    /// Prompts the user to create a new priority
    func addButtonTapped() {
        print(#function)
        
        let nameAlert = UIAlertController(title: "New Priority", message: nil, preferredStyle: .alert)
        nameAlert.addTextField(configurationHandler: nil)
        
        nameAlert.addAction(UIAlertAction(title: "OK", style: .default) { alertAction in
            self.dataModel?.priorities.append(Priority(name: nameAlert.textFields?[0].text ?? ""))
            print(self.dataModel as Any)
            self.dataModel?.writeToFile()
            self.tableView.reloadData()
        })
        nameAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(nameAlert, animated: true, completion: nil)
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel?.priorities.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell
        cell.textLabel?.text = dataModel?.priorities[indexPath.row].name

        return cell
    }

    
    // Support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // All items editable
        return true
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showTaskList" {
            if let destination = segue.destination as? TaskListViewController,
                    let indexPath = tableView.indexPathForSelectedRow {
                destination.priority = dataModel?.priorities[indexPath.row]
            }
        }
    }
    

}
