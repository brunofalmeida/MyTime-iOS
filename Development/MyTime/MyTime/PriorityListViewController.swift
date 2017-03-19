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
        
        // TODO - TEST - sample priorities
        dataModel?.priorities.append(Priority(name: "Priority1", tasks: [
            Task(name: "Task11", timeInterval: TimeInterval(totalSeconds: 49)),
            Task(name: "Task12", timeInterval: TimeInterval(totalSeconds: 1500001))
        ]))
        dataModel?.priorities.append(Priority(name: "Priority2", tasks: [
            Task(name: "Task21", timeInterval: TimeInterval(totalSeconds: 1)),
            Task(name: "Task22", timeInterval: TimeInterval(totalSeconds: 99))
        ]))
        
        print("dataModel with sample data:")
        debugPrint(dataModel as Any)

//        // Uncomment the following line to preserve selection between presentations
//        self.clearsSelectionOnViewWillAppear = false

        // Display an Edit button in the navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print(#function)
        super.viewWillDisappear(animated)
        
        dataModel?.writeToFile()
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
            
            debugPrint(dataModel as Any)
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
