//
//  iOSUtilities.swift
//  MyTime
//
//  Created by Bruno Almeida on 2017-08-17.
//  Copyright © 2017 Bruno Almeida. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    /// A convenience initializer to use `Double` values without having to convert to `CGFloat`.
    @nonobjc
    convenience init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.init(red: CGFloat(red),
                  green: CGFloat(green),
                  blue: CGFloat(blue),
                  alpha: CGFloat(alpha))
    }
    
}


extension UIViewController {
    
    func setBackButtonTitle(_ title: String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: title,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
    }
    
    func setBackButtonTitleAsEmpty() {
        setBackButtonTitle("")
    }
    
    func setBackButtonTitleAsBack() {
        setBackButtonTitle("Back")
    }
    
}
