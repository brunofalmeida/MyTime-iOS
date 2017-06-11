//
//  AnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-06-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit

class AnalysisViewController: UITableViewController {
    
    fileprivate weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    var dateIntervals: [DateInterval] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDateIntervals()
    }
    
    /// Populates `dateIntervals` with weeks containing one or more tasks.
    func populateDateIntervals() {
        if let dataModel = dataModel {
            // Map each task to the date interval of the week of its start time
            let rawDateIntervals = dataModel.allTasks.map { $0.startTime.dateIntervalForWeek() }
            
            // Remove duplicates
            dateIntervals = Array<DateInterval>(Set<DateInterval>(rawDateIntervals))
            
            // Sort (most recent first)
            dateIntervals.sort()
            dateIntervals.reverse()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateIntervals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dateIntervals[indexPath.row].formatForWeek
        return cell
    }

}



