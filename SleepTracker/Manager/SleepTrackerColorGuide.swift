//
//  SleepTrackerColorGuide.swift
//  SleepTracker
//
//  Created by Vikhyath on 11/03/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

struct STColorGuide {
    
    static var STPurple: UIColor {
        return makeSolidColor(red: 36, green: 34, blue: 58)
    }
    
    static var STLightPurple: UIColor {
        return makeSolidColor(red: 95, green: 92, blue: 135, alpha: 0.3)
    }
    
    static var pulsatingBlue: UIColor {
        return makeSolidColor(red: 95, green: 92, blue: 135, alpha: 0.3)
    }
    
    static func makeSolidColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}
