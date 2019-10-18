//
//  TimeManager.swift
//  Sensors
//
//  Created by Vikhyath on 12/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import Foundation

class TimeManager: NSObject {
    
    static let shared = TimeManager()
    
    fileprivate var timer: Timer?
    var counter = 0
    
    func startTimer() {
        
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
        
    }
    
    @objc private func handleTimer() {
        
        counter += 1
    }
    
    private func stopTimer() {
        guard timer != nil else { return }
        timer?.invalidate()
        timer = nil
    }
}
