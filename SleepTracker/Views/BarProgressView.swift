//
//  BarProgressView.swift
//  dummy
//
//  Created by Vikhyath on 19/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

@IBDesignable
class BarProgressView: UIView {
    
    @IBInspectable var percentDisturbedSleepView: CGFloat = 33 {
        didSet {
            disturbSleepWidth = percentDisturbedSleepView/100*frame.width
            updateView()
        }
    }
    
    @IBInspectable var percentNormalSleepView: CGFloat = 33 {
        didSet {
            normalSleepWidth = percentNormalSleepView/100*frame.width
            updateView()
        }
    }
    
    @IBInspectable var numberOfHours: CGFloat = 8 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var percentphoneCallSleepView: CGFloat = 34 {
        didSet {
            phoneCallWidth = percentphoneCallSleepView/100*frame.width
            updateView()
        }
    }
    
    @IBInspectable var disturbedViewColor: UIColor = .red {
        didSet {
            updateView()
        }
    }
    @IBInspectable var normalViewColor: UIColor = .blue {
        didSet {
            updateView()
        }
    }
    @IBInspectable var phoneCallViewColor: UIColor = .green {
        didSet {
            updateView()
        }
    }
    
    var disturbedSleepView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        
        return view
    }()
    var normalSleepView = UIView()
    var phoneCallView = UIView()
    var disturbSleepWidth: CGFloat = 0
    var normalSleepWidth: CGFloat = 0
    var phoneCallWidth: CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialise()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //initialise()
        layoutIfNeeded()
    }
    
    func updateView() {
        
        //layer.cornerRadius = 10
        normalSleepWidth = numberOfHours*frame.width/24
        if numberOfHours == 0 {
            normalSleepWidth = 0
        }
        layoutIfNeeded()
        normalSleepView.backgroundColor = normalViewColor
        disturbedSleepView.backgroundColor = disturbedViewColor
        phoneCallView.backgroundColor = phoneCallViewColor
        normalSleepView.frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: normalSleepWidth - 20, height: self.bounds.height)
        //        disturbedSleepView.frame = CGRect(x: normalSleepView.bounds.maxX, y: self.bounds.origin.y, width: disturbSleepWidth, height: self.bounds.height)
        //        phoneCallView.frame = CGRect(x: disturbedSleepView.frame.maxX, y: bounds.origin.y, width: phoneCallWidth, height: self.bounds.height)
    }
    
    func initialise() {
        
        layer.cornerRadius = frame.width / 2
        addSubview(normalSleepView)
        //addSubview(disturbedSleepView)
        //addSubview(phoneCallView)
        //        disturbSleepWidth = percentDisturbedSleepView/100*frame.width
        
        //        phoneCallWidth = percentphoneCallSleepView/100*frame.width
        updateView()
    }
}
