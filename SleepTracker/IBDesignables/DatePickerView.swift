//
//  DatePickerView.swift
//  Sensors
//
//  Created by Vikhyath on 13/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

@IBDesignable
class CustomDatePicker: UIDatePicker {
    
    let keyPath = "textColor"
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        initialise()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialise()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialise()
    }

    private func initialise() {
        
        self.setValue(UIColor.white, forKeyPath: keyPath)
    }
}
