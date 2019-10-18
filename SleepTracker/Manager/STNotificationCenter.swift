//
//  STNotificationCenter.swift
//  SleepTracker
//
//  Created by Vikhyath on 07/03/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import Foundation
class STNotificationCenter {
    
    // MARK: - Singleton initializer
    static let shared = STNotificationCenter()
    
    fileprivate init() {
        
    }
    
    func addObserver(_ observer: AnyObject, selector: Selector, name: String) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: nil)
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    func removeObserver(_ observer: AnyObject, name: String, object: AnyObject?) {
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
    }
    
    func removeObserver(_ observer: AnyObject) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    func postNotificationName(_ aName: String) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: aName), object: nil)
    }
    
}
