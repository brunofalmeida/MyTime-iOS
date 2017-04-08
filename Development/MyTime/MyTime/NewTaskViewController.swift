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
    
    // Set a temporary Date value
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
        
        // Set the timer circle's size and colour
        // rgb(135,206,250) - lightskyblue from http://www.rapidtables.com/web/color/blue-color.htm
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.backgroundColor = UIColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 0.5)
        
        // Initialize the timer's start time (now is more accurate than object initialization)
        startTime = Date()
        
        // Fire a timer every 0.1s, to update the timer
        _ = Timer.scheduledTimer(timeInterval: 0.1,
                                 target: self,
                                 selector: #selector(handleTimer),
                                 userInfo: nil,
                                 repeats: true)
    }
    
    /// Timer loop handler
    func handleTimer() {
        timerLabel.text = elapsedTimeInterval.description
    }
    
    
    override func willMove(toParentViewController parent: UIViewController?) {
        print()
        print(#function)
        super.willMove(toParentViewController: parent)
        
        // If it is being removed
        if parent == nil {
            // Update the parent with the elapsed time
            
            let savedTimeInterval = elapsedTimeInterval
            
            // Create an alert to ask the user to name the task
            let nameAlert = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
            nameAlert.addTextField(configurationHandler: nil)
            nameAlert.addAction(UIAlertAction(title: "OK", style: .default) { alertAction in
                //self.dataModel?.priorities[
                //self.dataModel.addTask(name: nameAlert.textFields?[0].text ?? "")
            })
            present(nameAlert, animated: true, completion: nil)
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

}
