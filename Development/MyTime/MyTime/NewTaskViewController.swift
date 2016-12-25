//
//  NewTaskViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class NewTaskViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    fileprivate var startTime: Date = Date()
    fileprivate var elapsedTimeInSeconds: Int {
        return -Int(startTime.timeIntervalSinceNow)
    }
    
    var parentMasterViewController: MasterViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //circleView.alpha = 0.5
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        // rgb(135,206,250) - lightskyblue from http://www.rapidtables.com/web/color/blue-color.htm
        circleView.backgroundColor = UIColor(red: 135/255.0, green: 206/255.0, blue: 250/255.0, alpha: 0.5)
        
        startTime = Date()
        
        _ = Timer.scheduledTimer(timeInterval: 0.1,
                                 target: self,
                                 selector: #selector(handleTimer),
                                 userInfo: nil,
                                 repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleTimer() {
        timerLabel.text = NewTaskViewController.formatTime(seconds: elapsedTimeInSeconds)
    }
    
    static func formatTime(seconds: Int) -> String {
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        print()
        print("willMove(toParentViewController:)")
        super.willMove(toParentViewController: parent)
        
        print("parent = \(parent)")
        print("self.parent = \(self.parent)")
        
        if parent == nil {
            self.parentMasterViewController?.addNewTask(timeInSeconds: elapsedTimeInSeconds)
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
