////
////  BackgroundTaskManager.swift
////  SleepTracker
////
////  Created by Vikhyath on 04/03/19.
////  Copyright © 2019 Vikhyath. All rights reserved.
////
//
//import UIKit
//
//class BackgroundTaskManager {
//    
//    static let shared = BackgroundTaskManager()
//    
//    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
//    
//    // Beginning the background task where 
//    func registerBackgroundTask() {
//        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
//            self?.endBackgroundTask()
//        }
//        assert(backgroundTask != .invalid)
//    }
//    
//    func endBackgroundTask() {
//        print("Background task ended.")
//        UIApplication.shared.endBackgroundTask(backgroundTask)
//        backgroundTask = .invalid
//    }
//}
//
