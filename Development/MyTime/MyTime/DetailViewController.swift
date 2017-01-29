//
//  DetailViewController.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-14.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var task: Task? {
        didSet {
            print("task.didSet: \(task)")
            // Update the view.
            self.configureView()
        }
    }


    func configureView() {
        // Update the user interface for the detail item.
        if let timeLabel = self.timeLabel {
            print("timeLabel exists")
            timeLabel.text = task?.timeInterval.description
        } else {
            print("timeLabel doesn't exist")
        }
        
        if let nameLabel = self.nameLabel {
            print("nameLabel exists")
            nameLabel.text = task?.name
        } else {
            print("nameLabel doesn't exist")
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

