//
//  DetailViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    var task: Task? {
        didSet {
            print("task.didSet")
            // Update the view.
            self.configureView()
        }
    }


    func configureView() {
        // Update the user interface for the detail item.
        if let task = self.task {
            if let label = self.detailDescriptionLabel {
                label.text = "Name: \(task.name)"
            }
            if let timeIntervalLabel = self.timeIntervalLabel {
                timeIntervalLabel.text = "Time: \(task.timeInterval.description)"
            }
            //title = task.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

}

