//
//  TimeInterval.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-29.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import Foundation

struct TimeInterval {
    fileprivate let totalSeconds: Int
    
    let hours: Int
    let minutes: Int
    let seconds: Int
    
    init(totalSeconds: Int) {
        self.totalSeconds = totalSeconds
        
        self.hours = totalSeconds / 3600
        self.minutes = (totalSeconds / 60) % 60
        self.seconds = totalSeconds % 60
    }
}

extension TimeInterval: CustomStringConvertible {
    var description: String {
        if hours == 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
