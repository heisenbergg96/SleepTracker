//
//  SleepTrackVC.swift
//  Sensors
//
//  Created by Vikhyath on 08/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import CallKit

class SleepTrackVC: BaseVC {
    
    @IBOutlet weak var bedTimingsLabel: UILabel!
    @IBOutlet weak var bedLateEarlyLabel: UILabel!
    @IBOutlet weak var wakeupTimelabel: UILabel!
    @IBOutlet weak var wakeupEarlyLateLabel: UILabel!
    
    @IBOutlet weak var circularProgressView: ProgressCircle!
    @IBOutlet weak var totalDurationLabel: UILabel!
    @IBOutlet weak var disturbedSleepLabel: UILabel!
    @IBOutlet weak var totalSleepLabel: UILabel!
    @IBOutlet weak var calldurationLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    let callObserver = CXCallObserver()
    var startDate: Date?
    var endDate: Date = Date()
    var isStarted: Bool = false
    var coredataManager = CoreDataManager()
    var startTime: Int = 0
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callObserver.setDelegate(self, queue: nil)
        // Hard coded value is given to the goal, can be replced by time difference in starttime and endtime in UserDefaultManager.
        circularProgressView.maximumValue = 300
        NotificationCenter.default.addObserver(self, selector: #selector(reinitiateBacgroundTask), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc fileprivate func reinitiateBacgroundTask() {
        if MotionManager.sharedInstance.timer != nil && backgroundTask == .invalid {
            //registerBackgroundTask()
        }
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    @objc fileprivate func openGoalSetScreen() {
        
        if UserDefaultManager.isGoalSet == false {
            guard let setGoalVC = storyboard?.instantiateViewController() else { return }
            present(setGoalVC, animated: true)
        }
    }
    
    fileprivate func stop() {
        
        //circularProgressView.stopAnimation()
        if backgroundTask != .invalid {
            endBackgroundTask()
        }
        saveToCoreData()
        handleupdateUI()
        startStopButton.setTitle("Start", for: .normal)
        isStarted = !isStarted
    }
    
    fileprivate func saveToCoreData() {
        
        MotionManager.sharedInstance.getSleepData { (disturbance, normalSleep, total, disturbedIntervals, callDurationInSession) in
            MotionManager.sharedInstance.stopQueuedUpdates()
            let sleepSession = SleepSession(startTime: startTime, stopTime: Int(Date().timeIntervalSince1970), intervals: disturbedIntervals, phoneCallDuration: callDurationInSession)
            coredataManager.insertRecord(sleepData: sleepSession, completion: { (status, errorMsg) in
                
                print(errorMsg)
               
            })
        }
    }
    
    fileprivate func start() {
        
        LocationManager.shared.startLocationUpdates()
        //registerBackgroundTask()
        startTime = Int(Date().timeIntervalSince1970)
        //circularProgressView.animatePulsatingLayer()
        resetUI()
        MotionManager.sharedInstance.startQueuedUpdates()
        isStarted = !isStarted
        startStopButton.setTitle("Stop", for: .normal)
    }
    
    fileprivate func resetUI() {
        
        calldurationLabel.text = "0h 0m 0s"
        disturbedSleepLabel.text = "0h 0m 0s"
        totalSleepLabel.text = "0h 0m 0s"
    }
    
    @objc fileprivate func handleupdateUI() {
        
        MotionManager.sharedInstance.getSleepData { (normalSleepDuration, disturbedSleepDuration, total, disturbedSleep, callDurationInSession) in
            print(normalSleepDuration)
            circularProgressView.progressValue = Float(total)
            disturbedSleepLabel.text  = disturbedSleepDuration.getHourMinuteSecond()
            totalSleepLabel.text = normalSleepDuration.getHourMinuteSecond()
            calldurationLabel.text = callDurationInSession.getHourMinuteSecond()
            let str = total.getHourMinuteSecond()
            totalDurationLabel.attributedText = AttributedString.getString(str: str)
        }
    }

    @IBAction func presentVC(_ sender: Any) {
        
        if isStarted {
            presentAlert("Already Running", body: "You cannot change the goal when tracker is running") {
                return
            }
        } else {
            guard let setgoalVC: SetGoalVC = storyboard?.instantiateViewController() else { return }
            present(setgoalVC, animated: true)
        }
    }
    
    
    @IBAction func gotosleep(_ sender: Any) {
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleupdateUI), userInfo: nil, repeats: true)
        isStarted ? stop() : start()
    }
    
    @IBAction func showHistory(_ sender: Any) {
        
        guard let sleepRecordVC: SleepRecordVC = storyboard?.instantiateViewController() else { return }
        present(sleepRecordVC, animated: true)
    }
}

// MARK :- CXCallObserverDelegate
extension SleepTrackVC: CXCallObserverDelegate {
    
    // delegate method that is fired when there is a incoming or a outgoing call.
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        
        if isStarted {
            if call.hasEnded == true && call.hasConnected == true {
                if let dur = startDate?.timeIntervalSinceNow {
                    onCall = false
                        MotionManager.sharedInstance.startQueuedUpdates()
                        MotionManager.sharedInstance.totalCallDuration += abs(Int(dur))
                }
            }
            
            if call.hasConnected == true && call.hasEnded == false {
                startDate = Date()
                onCall = true
                MotionManager.sharedInstance.stopQueuedUpdates()
            }
        }
    }
}
