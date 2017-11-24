//
//  GraphAnalysisViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-08-06.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import UIKit
import Charts

/**
 Displays a pie graph of the amount of time spent on each priority in the given date interval.
 
 The words "graph" and "chart" are used interchangeably here,
 since "graph" makes more sense to the user but the Charts library uses the term "chart".
 */
class GraphAnalysisViewController: UIViewController, IValueFormatter {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    /// The date interval being examined for time analysis.
    var dateInterval: DateInterval?
    /// The length of the date interval, used for string formatting.
    var dateIntervalLength: DateIntervalLength?
    
    /// Priorities mapped to the time spent on each.
    var prioritiesToTimeIntervals: [Priority: TimeInterval] = [:]
    /// `prioritiesToTimeIntervals` as a sorted array.
    var prioritiesToTimeIntervalsArray: [(key: Priority, value: TimeInterval)] = []
    
    /// Calculates the sum of all time intervals.
    var totalTimeInterval: TimeInterval {
        return TimeInterval(totalSeconds: prioritiesToTimeIntervalsArray
            .map { pair in pair.value }                                                 // Get the time intervals
            .reduce(0) { (result, timeInterval) in result + timeInterval.totalSeconds } // Sum the time intervals
        )
    }
    
    /// Some standard colours for the chart.
    static let standardColours: [UIColor] = [
        UIColor.red, UIColor.blue,                      // Primary
        UIColor.purple, UIColor.green, UIColor.orange,  // Secondary
        UIColor.cyan, UIColor.magenta                   // Other
    ]

    
    
    
    func setup(dateInterval: DateInterval,
               dateIntervalLength: DateIntervalLength,
               prioritiesToTimeIntervals: [Priority: TimeInterval]) {
        self.dateInterval = dateInterval
        self.dateIntervalLength = dateIntervalLength
        self.prioritiesToTimeIntervals = prioritiesToTimeIntervals
    }
    
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        if let dateIntervalLength = dateIntervalLength {
            title = dateInterval?.format(for: dateIntervalLength, stringLength: .long)
        } else {
            assertionFailure()
        }
        
        // Sort priorities from most time to least
        prioritiesToTimeIntervalsArray = Array(prioritiesToTimeIntervals).sorted(by: { $0.value > $1.value })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupChart()
    }
    
    /// Sets up and displays the data on the pie chart.
    func setupChart() {
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
        
        // Data set
        let dataSet = PieChartDataSet(values: values, label: nil)
        dataSet.colors = colours
        dataSet.valueFormatter = self
        
        // Data
        let data = PieChartData(dataSet: dataSet)
        
        // Chart
        pieChartView.drawHoleEnabled = false
        pieChartView.legend.enabled = false
        pieChartView.chartDescription?.text = nil
        pieChartView.data = data
    }
    
    
    // MARK: - IValueFormatter
    
    // Formats the text labels for each entry in the pie chart
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        
        let timeIntervalString = TimeInterval(totalSeconds: Int(value.rounded())).listDescription
        
//        let percent = value / Double(totalTimeInterval.totalSeconds) * 100.0
//        let percentString = String.init(format: "%.1f", percent) + "%"
        
        return timeIntervalString
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



