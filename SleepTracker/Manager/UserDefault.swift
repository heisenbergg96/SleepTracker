//
//  UserDefault.swift
//  Sensors
//
//  Created by Vikhyath on 08/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import Foundation

class UserDefaultManager: NSObject {
    
    class var startTime: Date? {
        get {
             return UserDefaults.standard.object(forKey: "starttime") as? Date
        } set (newValue) {
            UserDefaults.standard.set(newValue, forKey: "starttime")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var endTime: Date? {
        get {
            return UserDefaults.standard.object(forKey: "endTime") as? Date
        } set (newValue) {
            UserDefaults.standard.set(newValue, forKey: "endTime")
            UserDefaults.standard.synchronize()
        }
    }
    
    class var isGoalSet: Bool {
        get {
            return
                UserDefaults.standard.bool(forKey: "isGoalSet")
            
        } set (newValue) {
            UserDefaults.standard.set(newValue, forKey: "isGoalSet")
            UserDefaults.standard.synchronize()
        }
    }
    
}
