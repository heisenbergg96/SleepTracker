//
//  SetGoalVC.swift
//  Sensors
//
//  Created by Vikhyath on 13/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit
import Foundation

struct AlertAction {
    
    var title: String
    var action: ((UIAlertAction) -> Void)?
}

class SetGoalVC: BaseVC {
    
    @IBOutlet weak var todaysDate: UILabel!
    @IBOutlet weak var sleepHours: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var sleepEndTimeLabel: UILabel!
    @IBOutlet weak var sleepStartTimeLabel: UILabel!
    @IBOutlet weak var sleepEndLabel: UIView!
    @IBOutlet weak var sleepStartLabel: UIView!
    @IBOutlet weak var datePickerBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: CustomDatePicker!
    @IBOutlet weak var goalProgressBar: BarProgressView!
    
    var tag: Int = 1
    var sleepStart: Date?
    var sleepEnd: Date?
    var isLaunchedFirst = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleepStartLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        sleepEndLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :))))
        
        todaysDate.text = "\(Date().today)"
        if isLaunchedFirst == true {
            // Default goal is set from 10pm to 6am.
            UserDefaultManager.startTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())
            UserDefaultManager.endTime = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date.tomorrow())
        }
        sleepStart = UserDefaultManager.startTime
        sleepEnd = UserDefaultManager.endTime
        setupUI()
        goalProgressBar.layer.cornerRadius = goalProgressBar.frame.height / 2
    }
    
    func setupUI() {
        
        guard let start = sleepStart, let end = sleepEnd else {
            return
        }
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: start, to: end)
        guard let goalHours = timeComponents.hour, let goalMinutes = timeComponents.minute else { return }
        /* If the endtime is 12 hours more than the starttime, then the difference would be a negative value, hence added to 24 to get the magnitude */
        let actualGoalHours = goalHours >= 24 ? goalHours - 24 : goalHours
        let actualGoalMinutes = goalMinutes < 0 ? 60 + goalMinutes : goalMinutes
        sleepHours.attributedText = AttributedString.getAttributedString(str: "\(actualGoalHours)h \(actualGoalMinutes)m")
//        slider.value = Float(actualGoalHours)
        goalProgressBar.numberOfHours = CGFloat(actualGoalHours)
        
        var goalComponents = Calendar.current.dateComponents([.hour, .minute], from: start)
        guard let h = goalComponents.hour, let m = goalComponents.minute else {
            return
        }
        var time = Date.getTimeInFormat(hour: h, minute: m)
        sleepStartTimeLabel.text = time
        
        goalComponents = Calendar.current.dateComponents([.hour, .minute], from: end)
        guard let endhour = goalComponents.hour, let endmin = goalComponents.minute else {
            return
        }
        time = Date.getTimeInFormat(hour: endhour, minute: endmin)
        sleepEndTimeLabel.text = time
    }
    
    
    @objc fileprivate func handleTap(_ gestureRecognizer : UITapGestureRecognizer) {
        
        guard let start = sleepStart, let end = sleepEnd else { return }
        datePicker.date = gestureRecognizer.view?.tag == 1 ? end : start
        // disable the userinteraction of the labels when the date picker is launched.
        sleepEndLabel.isUserInteractionEnabled = false
        sleepStartLabel.isUserInteractionEnabled = false
        if let tagId = gestureRecognizer.view?.tag {
            tag = tagId
            gestureRecognizer.view?.alpha = 1
        }
        
        UIView.animate(withDuration: 0.3) {
            // changing the container view bottom constraint to 0 to launch the picker view, else the bottom constraint is -100.
            self.datePickerBottonConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pickDateAction(_ sender: UIDatePicker) {
        
        var time = ""
        let goalComponents = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        guard let h = goalComponents.hour, let m = goalComponents.minute else {
            return
        }
        time = Date.getTimeInFormat(hour: h, minute: m)
        if tag == 2 {
            sleepStartTimeLabel.text = time
            sleepStart = sender.date
        } else {
            sleepEndTimeLabel.text = time
            sleepEnd = sender.date
           
        }
        setupUI()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        var alertActions: [AlertAction] = []
        alertActions.append(AlertAction(title: "Save", action: { (_) in
            UserDefaultManager.isGoalSet = true
            if let start = self.sleepStart {
                UserDefaultManager.startTime = start
            }
            if let endTime =  self.sleepEnd {
                UserDefaultManager.endTime = endTime
            }
            (UIApplication.shared.delegate as? AppDelegate)?.gotoSleepTracker()
        }))
        alertActions.append(AlertAction(title: "Cancel", action: nil))
        presentAlert(title: "Goal Set", body: "Do you want to save your goal", alertActions: alertActions)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        
        guard let start = sleepStart, let end = sleepEnd else {
            return
        }
        // values in the date picker has to be updated based on the picker value.
        datePicker.date = tag == 1 ? start : end
        if tag == 1 {
            tag = 2
            sleepEndLabel.alpha = 1
            sleepStartLabel.alpha = 0.5
        } else {
            tag = 1
            sleepStartLabel.alpha = 1
            sleepEndLabel.alpha = 0.5
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        sleepStartLabel.isUserInteractionEnabled = true
        sleepEndLabel.isUserInteractionEnabled = true
        sleepEndLabel.alpha = 0.5
        sleepStartLabel.alpha = 0.5
        UIView.animate(withDuration: 0.7) {
            self.datePickerBottonConstraint.constant = -200
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        
        isLaunchedFirst ? (UIApplication.shared.delegate as? AppDelegate)?.gotoSleepTracker() : dismiss(animated: true, completion: nil)
    }
    
}
