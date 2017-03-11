//
//  Priority.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-03-10.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation

class Priority {
    var name: String
    var tasks: [Task] = []
    
    init(name: String) {
        self.name = name
    }
}
