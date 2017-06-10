//
//  NewTaskViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    fileprivate enum Segues: String {
        case showTaskDetail
    }

    fileprivate weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    fileprivate var timer: Timer?
    
    // The timer's start time (set a temporary value so it's non-nil)
    fileprivate var startTime: Date = Date()
    
    /// The timer's elapsed time
    fileprivate var elapsedTimeInSeconds: Int {
        return -Int(startTime.timeIntervalSinceNow)
    }
    
    /// The timer's elapsed time interval
    fileprivate var elapsedTimeInterval: TimeInterval {
        return TimeInterval(totalSeconds: elapsedTimeInSeconds)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the timer circle's size and colour
        // rgb(135,206,250) - lightskyblue (http://www.rapidtables.com/web/color/blue-color.htm)
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = UIColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 0.5)
        
        cancelTimer()
    }
    
    func cancelTimer() {
        print(#function)
        
        // Back button in top left
        navigationItem.leftBarButtonItem = nil
        
        // Start button in top right
        let startButton = UIBarButtonItem(title: "Start", style: .done, target: self, action: #selector(startButtonTapped))
        navigationItem.rightBarButtonItem = startButton
        
        // Stop the timer
        timer?.invalidate()
        timer = nil
        
        timerLabel.text = "0:00"
    }
    
    func startTimer() {
        print(#function)
        
        // Cancel button in top left
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        
        // Done button in top right
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        
        // Initialize the timer's start time
        // (setting it now is more accurate than when the object is initialized)
        startTime = Date()
        
        // Fire a system timer every 0.1s, to update the task timer
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(timerFired),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func startButtonTapped() {
        startTimer()
    }
    
    /**
     Cancel button event handler
     Pop to root view controller (priority list)
     */
    func cancelButtonTapped() {
        print(#function)
        cancelTimer()
//        _ = navigationController?.popViewController(animated: true)
    }
    
    /**
     Done button event handler
     Segue to task detail view
     */
    func doneButtonTapped() {
        print(#function)
        performSegue(withIdentifier: Segues.showTaskDetail.rawValue, sender: self)
    }
    
    /**
     Timer firing handler
     Updates the timer label text
     */
    func timerFired() {
        timerLabel.text = elapsedTimeInterval.description
    }

    
    // MARK: - Navigation

    // Prepare for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Task detail
        if let destination = segue.destination as? TaskDetailViewController {
            
            // Create a new task - default priority and name, end time is now
            let priority = dataModel?.defaultPriority
            let task = Task(name: DataModel.defaultTaskName, startTime: startTime, endTime: Date())
            priority?.addTask(task)
            
            destination.setup(task: task)
        }
    }

}



