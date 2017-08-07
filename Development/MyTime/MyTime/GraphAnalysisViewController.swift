//
//  GraphAnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-08-06.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit
import Charts

/// Displays a pie chart of the amount of time spent on each priority in the given date interval.
class GraphAnalysisViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    /// The date interval being examined for time analysis.
    var dateInterval: DateInterval?
    /// The length of the date interval, used for string formatting.
    var dateIntervalLength: DateIntervalLength?
    
    /// Priorities mapped to the time spent on each.
    var prioritiesToTimeIntervals: [Priority: TimeInterval] = [:]
    /// `prioritiesToTimeIntervals` as a sorted array.
    var prioritiesToTimeIntervalsArray: [(key: Priority, value: TimeInterval)] = []
    
    /// Some standard colours for the graph.
    static let standardColours: [UIColor] = [
        UIColor.red, UIColor.blue, UIColor.yellow,
        UIColor.purple, UIColor.green, UIColor.orange,
        UIColor.cyan, UIColor.magenta
    ]

    
    
    
    func setup(dateInterval: DateInterval,
               dateIntervalLength: DateIntervalLength,
               prioritiesToTimeIntervals: [Priority: TimeInterval]) {
        self.dateInterval = dateInterval
        self.dateIntervalLength = dateIntervalLength
        self.prioritiesToTimeIntervals = prioritiesToTimeIntervals
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        if let dateIntervalLength = dateIntervalLength {
            title = dateInterval?.format(for: dateIntervalLength)
        } else {
            assertionFailure()
        }
        
        // Sort priorities from most time to least
        prioritiesToTimeIntervalsArray = Array(prioritiesToTimeIntervals).sorted(by: { $0.value > $1.value })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupGraph()
    }
    
    /// Sets up and displays the data on the pie graph.
    func setupGraph() {
        var values: [PieChartDataEntry] = []
        var colours: [UIColor] = []
        
        // Loop through each priority and time
        for (i, pair) in prioritiesToTimeIntervalsArray.enumerated() {
            let (key, value) = pair
            
            // Add the time data, labelled with the priority
            values.append(PieChartDataEntry(value: Double(value.totalSeconds), label: key.name))
            
            // If there are any standard colours left, use the next one
            if i < GraphAnalysisViewController.standardColours.count {
                colours.append(GraphAnalysisViewController.standardColours[i])
                
            // If no standard colours are left, use a random colour
            } else {
                colours.append(UIColor(
                    red: Double.random(min: 0, max: 1),
                    green: Double.random(min: 0, max: 1),
                    blue: Double.random(min: 0, max: 1),
                    alpha: 1.0
                ))
            }
        }
        
        // Create the data set and graph
        let dataSet = PieChartDataSet(values: values, label: nil)
        dataSet.colors = colours
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

