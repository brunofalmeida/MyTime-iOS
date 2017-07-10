//
//  AnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-07-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class AnalysisViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DateIntervalLength.allCases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "By \(DateIntervalLength.allCases[indexPath.row].rawValue)"
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DateIntervalListViewController,
                let row = tableView.indexPathForSelectedRow?.row {
            destination.setup(dateIntervalLength: DateIntervalLength.allCases[row])
        }
    }
    

}
