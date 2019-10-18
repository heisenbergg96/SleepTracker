//
//  Sleep.swift
//  Sensors
//
//  Created by Vikhyath on 15/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import Foundation

class SleepInterval {
    
    var date: Int
    var session: [SleepSession]
    
    init(date: Int, session: [SleepSession]) {
        self.date = date
        self.session = session
    }
}

class SleepSession {
    
    var startTime: Int
    var stopTime: Int
    var phoneCallDuration: Int
    var intervals: [TimeInterval]
    
    init(startTime: Int, stopTime: Int, intervals: [TimeInterval], phoneCallDuration: Int) {
        
        self.startTime = startTime
        self.stopTime = stopTime
        self.phoneCallDuration = phoneCallDuration
        self.intervals = intervals
    }
}

class TimeInterval {
    
    var startTime: Int
    var endTime: Int
    
    init(startTime: Int, endTime: Int) {
        
        self.startTime = startTime
        self.endTime = endTime
    }
}


//VM for sleep record
