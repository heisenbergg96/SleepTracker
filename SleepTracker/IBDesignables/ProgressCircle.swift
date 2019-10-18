//
//  ProgressCircle.swift
//  Sensors
//
//  Created by Vikhyath on 13/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//


import UIKit

@IBDesignable class ProgressCircle: UIView, CAAnimationDelegate {
    
    @IBInspectable public var clockWise: Bool = true { didSet { redraw() }}
    
    @IBInspectable public var minimumValue: Float = 0.0 { didSet { redraw() }}
    @IBInspectable public var maximumValue: Float = 30.0 { didSet { redraw() }}
    @IBInspectable public var trackColor: UIColor = .lightGray { didSet { redraw() }}
    @IBInspectable public var progressColor: UIColor = .orange { didSet { redraw() }}
    @IBInspectable public var dottedLineColor: UIColor = .blue { didSet { redraw() }}
    @IBInspectable public var progressLineWidth: CGFloat = 7 { didSet { redraw() }}
    @IBInspectable public var trackLineWidth: CGFloat = 7 { didSet { redraw() }}
    @IBInspectable public var dottedLineWidth: CGFloat = 7 { didSet { redraw() }}
    
    @IBInspectable public var gardientColor1: UIColor = .red { didSet { redraw() }}
    @IBInspectable public var gardientColor2: UIColor = .yellow { didSet { redraw() }}
    @IBInspectable public var gardientColor3: UIColor = .orange { didSet { redraw() }}
    @IBInspectable public var gardientColor4: UIColor = .blue { didSet { redraw() }}
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            redraw()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.white {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGFloat = 0 {
        didSet {
            layer.shadowOffset = CGSize(width: 0, height: shadowOffset)
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var progressValue: Float = 0.0 {
        didSet {
            progressValue = min(maximumValue, max(minimumValue, progressValue))
            progressValue = (progressValue - minimumValue) / (maximumValue - minimumValue)
            redraw()
            setNeedsLayout()
        }
    }
    @IBInspectable public var startAngle: CGFloat = 90 { didSet { redraw()} }
    @IBInspectable public var endAngle: CGFloat = 270 { didSet { redraw() } }
    
    var trackLayer = CAShapeLayer()
    var progressLayer = CAShapeLayer()
    var gradient = CAGradientLayer()
    var linelayer = CAShapeLayer()
    var dottedLayer = CAShapeLayer()
    var pulsatingLayer = CAShapeLayer()
    let label: UILabel = {
        
        let label = UILabel()
        label.text = "Test!!"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 35)
        label.backgroundColor = .white
        return label
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        
        trackLayer.fillColor = STColorGuide.STPurple.cgColor
        trackLayer.strokeEnd = 1
        trackLayer.lineCap = .round
        
        pulsatingLayer.fillColor = STColorGuide.pulsatingBlue.cgColor
        pulsatingLayer.strokeColor = trackLayer.strokeColor
        pulsatingLayer.lineWidth = trackLayer.lineWidth
        pulsatingLayer.lineCap = .round
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        
        layer.addSublayer(pulsatingLayer)
        layer.addSublayer(trackLayer)
        layer.addSublayer(gradient)
        
    }
    
    private func redraw() {
        
        //For drawing the circle
        //Track Layer bounds is set to circular view's bounds when constraints are updated.
        trackLayer.bounds = bounds
        
        let startAngleInRadians = startAngle * CGFloat.pi / 180
        let endAngleInRadians = endAngle * CGFloat.pi / 180
        let centre = CGPoint(x: trackLayer.bounds.width/2, y: trackLayer.bounds.height/2)
        let radius = min(trackLayer.bounds.width, trackLayer.bounds.height)/2 - max(progressLineWidth, trackLineWidth)
        let ring = UIBezierPath(arcCenter: centre, radius: radius, startAngle: startAngleInRadians, endAngle: endAngleInRadians, clockwise: clockWise)
        let boundRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        
        pulsatingLayer.bounds = trackLayer.bounds
        pulsatingLayer.position = trackLayer.position
        pulsatingLayer.lineWidth = progressLineWidth
        pulsatingLayer.path = ring.cgPath
        
        trackLayer.path = ring.cgPath
        trackLayer.bounds = boundRect
        trackLayer.position = CGPoint(x: boundRect.width / 2, y: boundRect.height / 2)
        trackLayer.lineWidth = trackLineWidth
        trackLayer.strokeColor = trackColor.cgColor
        
        progressLayer.path = ring.cgPath
        progressLayer.bounds = trackLayer.bounds
        progressLayer.position = trackLayer.position
        progressLayer.lineWidth = progressLineWidth
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.strokeEnd = CGFloat(progressValue)
        
        gradient.colors = [gardientColor1.cgColor, gardientColor2.cgColor, gardientColor3.cgColor, gardientColor4.cgColor]
        gradient.bounds = trackLayer.bounds
        gradient.position = trackLayer.position
        gradient.mask = progressLayer
    }
    
    
    func animatePulsatingLayer() {
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.2
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    func stopAnimation() {
        
        pulsatingLayer.removeAllAnimations()
    }
}
