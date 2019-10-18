//
//  STButton.swift
//  SleepTracker
//
//  Created by Vikhyath on 04/03/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

class STButton: UIButton {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if imageView != nil {
            // image is placed on the right hand side of the button
            imageEdgeInsets = UIEdgeInsets(top: 15, left: (bounds.width - 35), bottom: 15, right: 15)
        }
    }
}
