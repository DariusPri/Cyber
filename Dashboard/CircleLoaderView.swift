//
//  CircleLoaderView.swift
//  Xpert
//
//  Created by Darius on 27/06/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit
import AEConicalGradient

class CircleLoaderView: UIView {
    
    let gradientView = ConicalGradientView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientView.gradient.colors = [UIColor(red: 219/255, green: 20/255, blue: 25/255, alpha: 1),
                                        UIColor(red: 247/255, green: 146/255, blue: 2/255, alpha: 1),
                                        UIColor(red: 1, green: 199/255, blue: 3/255, alpha: 1),
                                        UIColor(red: 104/255, green: 207/255, blue: 35/255, alpha: 1),
                                        UIColor(red: 6/255, green: 192/255, blue: 190/255, alpha: 1)]
        gradientView.transform = CGAffineTransform(rotationAngle: .pi/2)
        addSubview(gradientView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: gradientView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: gradientView)
        gradientView.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.clear.cgColor
        layer.lineWidth = 4
        setPath()
    }
    
    let circleLayer = CAShapeLayer();
    let roundLayer = CAShapeLayer();
    
    let spacing : CGFloat = 10

    private func setPath() {
        
        let center = CGPoint(x: bounds.size.height/2, y: bounds.size.width/2)
        
        roundLayer.path = UIBezierPath(arcCenter: center, radius: self.bounds.size.width/2 - layer.lineWidth/2 - spacing * 2, startAngle: CGFloat(0.1), endAngle: CGFloat(.pi * 1.95), clockwise: true).cgPath
        roundLayer.fillColor = UIColor.clear.cgColor
        roundLayer.strokeColor = UIColor.brown.cgColor
        roundLayer.lineWidth = 4
        roundLayer.strokeStart = 0
        roundLayer.strokeEnd = 2
        roundLayer.lineCap = CAShapeLayerLineCap.round
        
        layer.path = UIBezierPath(arcCenter: center, radius: self.bounds.size.width/2 - layer.lineWidth/2 - spacing * 2, startAngle: CGFloat(0), endAngle: CGFloat(.pi * 2.0), clockwise: true).cgPath
        layer.lineCap = CAShapeLayerLineCap.round
        
        layer.path = layer.path
        layer.lineWidth = 1
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineJoin = CAShapeLayerLineJoin.round
        layer.lineDashPattern = [6,6]
        
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: (bounds.size.height/2)-4 - spacing * 2, width: 4, height: 4)).cgPath;
        circleLayer.fillColor = UIColor.red.cgColor
        circleLayer.position = center
        
        roundLayer.addSublayer(circleLayer)
        
        roundLayer.shadowColor = UIColor(red: 144/255, green: 151/255, blue: 161/255, alpha: 1).cgColor
        roundLayer.shadowRadius = 10
        roundLayer.shadowOffset = .zero
        roundLayer.shadowOpacity = 0.6
        
        gradientView.layer.mask = roundLayer
        
    }
    
    var score : CGFloat = 0
    var animateToScore : CGFloat = 0
    private let totalScoreCount : CGFloat = 1000
    
    var duration : Double = 2
    
    func animate() {
        circleLayer.removeAllAnimations()
        roundLayer.removeAllAnimations()
          
        let animation1 = CABasicAnimation(keyPath: "strokeEnd")
        animation1.fromValue = score/totalScoreCount
        animation1.toValue = 1 * (animateToScore/totalScoreCount)
        animation1.duration = duration
        animation1.repeatCount = 1
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation1.isRemovedOnCompletion = false
        animation1.fillMode = CAMediaTimingFillMode.forwards
        roundLayer.add(animation1, forKey: "aaa")
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        let currentPercent : CGFloat = score / totalScoreCount
        let multiplier = (((2 * .pi)) - 0.2) * (currentPercent)
        animation.fromValue = CGFloat(multiplier + (0.2 - .pi/2))
        animation.toValue = CGFloat(.pi * (2 * (animateToScore/totalScoreCount) - 0.5)) + (0.2 * (1 - (animateToScore/totalScoreCount)))
        animation.duration = duration
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        circleLayer.add(animation, forKey: "aaa")
        
        score = animateToScore
    }

}
