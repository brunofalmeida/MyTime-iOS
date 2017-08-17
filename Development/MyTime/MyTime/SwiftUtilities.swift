//
//  SwiftUtilities.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-08-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation


extension Int {
    
    /// - Returns: A random integer in the range [min, max] (inclusive).
    static func random(min: Int, max: Int) -> Int {
        return Int(arc4random()) % (max - min + 1) + min
    }
    
}


extension Double {
    
    /// - Returns: A random double in the range [0, 1] (inclusive).
    private static func random0To1() -> Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
    
    /// - Returns: A random double in the range [min, max] (inclusive).
    static func random(min: Double, max: Double) -> Double {
        return random0To1() * (max - min) + min
    }
    
}


/**
 Prints an optional value without having to cast to `Any`.
 */
func print(optional: Any?) {
    print(optional as Any)
}

/**
 Calculates an `Int` power without having to cast to `Double`.
 */
func pow(base: Int, exponent: Int) -> Int {
    return Int( pow(Double(base), Double(exponent)) )
}
