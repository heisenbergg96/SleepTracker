//
//  CustomButton.swift
//  Sensors
//
//  Created by Vikhyath on 14/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

class CustomButtom: UIButton {
    
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
}
