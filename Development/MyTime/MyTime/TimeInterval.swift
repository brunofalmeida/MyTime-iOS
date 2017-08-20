//
//  TimeInterval.swift
//  MyTime
//
//  Created by Bruno Almeida on 2016-12-29.
//  Copyright © 2016 Bruno Almeida. All rights reserved.
//

import Foundation

/// A period of time elapsed. Only stores the length of time elapsed, not when it started and ended.
class TimeInterval: NSObject, NSCoding {
    
    /// Keys for reading/writing the object from/to a file
    fileprivate enum CodingKeys: String {
        case totalSeconds
    }
    
    
    /// Total time elapsed
    let totalSeconds: Int
    
    /// Hours time component
    let hours: Int
    /// Minutes time component
    let minutes: Int
    /// Seconds time component
    let seconds: Int
    
    init(totalSeconds: Int) {
        self.totalSeconds = totalSeconds
        
        self.hours = totalSeconds / 3600
        self.minutes = (totalSeconds / 60) % 60
        self.seconds = totalSeconds % 60
        
        super.init()
    }
    
    
    // MARK: NSCoding
    
    // Read from a file
    required convenience init?(coder aDecoder: NSCoder) {
        let totalSeconds = aDecoder.decodeInteger(forKey: CodingKeys.totalSeconds.rawValue)
        
        if totalSeconds != 0 {
            self.init(totalSeconds: totalSeconds)
        } else {
            return nil
        }
    }
    
    // Write to a file
    func encode(with aCoder: NSCoder) {
        aCoder.encode(totalSeconds, forKey: CodingKeys.totalSeconds.rawValue)
    }
    
}


extension TimeInterval {
    override var description: String {
        if hours == 0 {
            return String(format: "%d:%02d", minutes, seconds)
        } else {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
    }
    
    var listDescription: String {
        if hours == 0 && minutes == 0 {
            return "\(seconds)s"
        } else if hours == 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(hours)h \(minutes)m \(seconds)s"
        }
    }
    
    override var debugDescription: String {
        return "\(type(of: self))(totalSeconds = \(totalSeconds), hours = \(hours), minutes = \(minutes), seconds = \(seconds))"
    }
}


func ==(left: TimeInterval, right: TimeInterval) -> Bool {
    return left.totalSeconds == right.totalSeconds
}

func !=(left: TimeInterval, right: TimeInterval) -> Bool {
    return !(left == right)
}

func >(left: TimeInterval, right: TimeInterval) -> Bool {
    return left.totalSeconds > right.totalSeconds
}

func +(left: TimeInterval, right: TimeInterval) -> TimeInterval {
    return TimeInterval(totalSeconds: left.totalSeconds + right.totalSeconds)
}



