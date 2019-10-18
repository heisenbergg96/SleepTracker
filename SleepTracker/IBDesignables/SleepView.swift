//
//  SleepView.swift
//  Sensors
//
//  Created by Vikhyath on 13/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import UIKit

@IBDesignable
class SleepView: UIView {
    
    @IBInspectable var layerColor: CGColor = UIColor(red: 51/255, green: 46/255, blue: 76/255, alpha: 1).cgColor {
        didSet {
            redraw()
        }
    }
    
    @IBInspectable var layerborderColor: CGColor = UIColor(red: 108/255, green: 103/255, blue: 143/255, alpha: 0.1).cgColor {
        didSet {
            redraw()
        }
    }
    
    @IBInspectable var layerborderWidth: CGFloat = 3 {
        didSet {
            redraw()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        redraw()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
         redraw()
    }
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations( { () -> Void in
                self.layer.backgroundColor = UIColor.blue.withAlphaComponent(0.2).cgColor
            }, completion: nil)
            
        } else if context.previouslyFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.layer.backgroundColor = UIColor.clear.cgColor
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         redraw()
    }
    
    private func redraw() {
        
        layer.cornerRadius = frame.height / 2
        layer.backgroundColor = layerColor
        layer.borderColor = layerborderColor
        layer.borderWidth = layerborderWidth
        layoutIfNeeded()
    }
}
