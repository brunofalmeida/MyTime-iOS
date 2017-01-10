//
//  TimeInterval.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-29.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import Foundation

class TimeInterval: NSCoding {
    
    fileprivate enum CodingKeys: String {
        case totalSeconds
    }
    
    
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
    
    // MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let totalSeconds = aDecoder.decodeInteger(forKey: CodingKeys.totalSeconds.rawValue)
        
        if totalSeconds != 0 {
            self.init(totalSeconds: totalSeconds)
        } else {
            return nil
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(totalSeconds, forKey: CodingKeys.totalSeconds.rawValue)
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

extension TimeInterval: CustomDebugStringConvertible {
    var debugDescription: String {
        return "TimeInterval(totalSeconds = \(totalSeconds), hours = \(hours), minutes = \(minutes), seconds = \(seconds))"
    }
}

