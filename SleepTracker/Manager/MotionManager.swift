//
//  MotionManager.swift
//  Sensors
//
//  Created by Vikhyath on 05/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import CoreMotion
//var counter = 0
var onCall: Bool = false
var isStepCountStarted = false
var stepCounter = 0

enum State {
    
    case distubance
    case normal
}


class MotionManager: NSObject {
    
    private let activityManager = CMMotionActivityManager()
    private var pedometer = CMPedometer()
    var preX: Double = 0.001, preY: Double = 0.001, preZ: Double = 0.001
    let motion = CMMotionManager()
    let deviceMotion = CMDeviceMotion()
    var disturbedSleepDuration = 0
    var timer: Timer?
    var currentX: Double = 0
    var currentY: Double = 0
    var currentZ: Double = 0
    var diffX: Double = 0
    var diffY: Double = 0
    var diffZ: Double = 0
    var sleepDuration: Int = 0
    var current: State = .normal
    var disturbedSleep: [TimeInterval] = []
    var normalSleep: [TimeInterval] = []
    var startDisturbance: Int = 0
    var startNormalSleep: Int = 0
    var stopDisturbance: Int = 0
    var totalCallDuration: Int = 0
    
    var accelerometerHandler: ((Double, Double, Double) -> Void)?
    static let sharedInstance: MotionManager = MotionManager()
    
    private override init() {
        super.init()
        pedometer = CMPedometer()
    }
    
    func isStationary() {
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTrackingActivityType), userInfo: nil, repeats: true)
    }
    
    @objc private func startTrackingActivityType() {
        
        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity: CMMotionActivity?) in
            
            guard let activity = activity else { return }
                  if activity.stationary {
                    //self.counter += 1
                    //print(self.counter)
            }
        }
    }
    
    func startPadameterUpdates() {
        
        pedometer.startUpdates(from: Date(), withHandler: { pedometerData, error in
            
            if let err = error {
                print(err)
            }
            isStepCountStarted = true
            
        })
    }
    
    func startAccelerometers() {
        // Make sure the accelerometer hardware is available.
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 1.0  // 60 Hz
            motion.startAccelerometerUpdates()
            
            // Configure a timer to fetch the data.
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            
            // Add the timer to the current run loop.
            
            //RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
        }
    }
    
    @objc func update() {
        
        if (motion.isAccelerometerActive) {
            
            if let data = motion.accelerometerData {
                
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z
//                velocity += (z * 0.1)
//                distanceMoved += velocity * 0.1
                preX = x
                preY = y
                preZ = z
                
            }
        }
    }
    
    func startGyroscope() {
        
        if motion.isGyroAvailable {
            motion.gyroUpdateInterval = 1.0 / 60.0
            motion.startGyroUpdates()
            
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateGyro), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateGyro() {
        
        if let data = motion.gyroData {
            
            let x = data.rotationRate.x
            let y = data.rotationRate.y
            let z = data.rotationRate.z
            print(x, y, z)
            
            preX = x
            preY = y
            preZ = z
        }
    }
    
    func startQueuedUpdates() {
        
        //BackgroundTaskManager.shared.registerBackgroundTask()
        startNormalSleep = Int(Date().timeIntervalSince1970)
        if motion.isDeviceMotionAvailable && !motion.isDeviceMotionActive {
            
            motion.deviceMotionUpdateInterval = 1.0
            motion.showsDeviceMovementDisplay = true
            motion.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func resetVariables() {
        totalCallDuration = 0
        sleepDuration = 0
        disturbedSleepDuration = 0
        disturbedSleep.removeAll()
    }
    
    func stopQueuedUpdates() {
        
        
        if let tim = timer {
            timer = nil
            tim.invalidate()
        }
        if !onCall {
            resetVariables()
        }
        
        if motion.isDeviceMotionActive {
            motion.stopDeviceMotionUpdates()
        }
        //counter = 0
//        sleepDuration = 0
//        totalCallDuration = 0
    }
    
    @objc func updateDeviceMotion() {
        
        if let data = motion.deviceMotion {
            
            currentX = abs(data.gravity.x)
            currentY = abs(data.gravity.y)
            currentZ = abs(data.gravity.z)
            
            diffX = currentX - preX
            diffY = currentY - preY
            diffZ = currentZ - preZ
            
            if diffX > 0.001 || diffY > 0.001 || diffZ > 0.001 {
                disturbedSleepDuration += 1
                if current == .normal {
                    startDisturbance = Int(Date().timeIntervalSince1970)
                    current = .distubance
                }
            } else {
                if current == .distubance {
                    if Int(Date().timeIntervalSince1970) - startDisturbance > 5 {
                        disturbedSleep.append(TimeInterval(startTime: startDisturbance, endTime: Int(Date().timeIntervalSince1970)))
                        startNormalSleep = Int(Date().timeIntervalSince1970)
                    }
                    current = .normal
                }
                sleepDuration += 1
            }
            preX = currentX
            preY = currentY
            preZ = currentZ
            
        }
    }
    
    func getSleepData(completion: (Int, Int, Int, [TimeInterval], Int) -> Void) {
        
        completion(sleepDuration, disturbedSleepDuration, sleepDuration + disturbedSleepDuration, disturbedSleep, totalCallDuration)
    }
}
