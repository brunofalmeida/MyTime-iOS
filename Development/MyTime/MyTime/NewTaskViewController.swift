//
//  NewTaskViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {

    weak var dataModel = (UIApplication.shared.delegate as? AppDelegate)?.dataModel
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
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
        // Do any additional setup after loading the view.
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
        
        // Set the timer circle's size and colour
        // rgb(135,206,250) - lightskyblue from http://www.rapidtables.com/web/color/blue-color.htm
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = UIColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 0.5)
        
        // Initialize the timer's start time (setting it now is more accurate than when the object is initialized)
        startTime = Date()
        
        // Fire a timer every 0.1s, to update the timer
        _ = Timer.scheduledTimer(timeInterval: 0.1,
                                 target: self,
                                 selector: #selector(handleTimer),
                                 userInfo: nil,
                                 repeats: true)
    }
    
    func cancelButtonTapped() {
        print(#function)
        _ = navigationController?.popViewController(animated: true)
    }
    
    func doneButtonTapped() {
        print(#function)
        performSegue(withIdentifier: "showTaskDetail", sender: self)
    }
    
    
    /// Timer loop handler
    func handleTimer() {
        timerLabel.text = elapsedTimeInterval.description
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destination = segue.destination as? TaskDetailViewController {
            let priority = dataModel?.defaultPriority
            let task = Task(name: DataModel.defaultTaskName, timeInterval: elapsedTimeInterval)
            priority?.tasks.append(task)
            
            destination.priority = priority
            destination.task = task
        }
    }

}



