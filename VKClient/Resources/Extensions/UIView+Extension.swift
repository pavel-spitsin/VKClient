//
//  UIView+Extension.swift
//  VKClient
//
//  Created by Павел on 12.04.2024.
//

import UIKit

extension UIView {
    func errorShakeAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.03
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 8,
                                                       y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 8,
                                                     y: self.center.y))
        self.layer.add(animation, forKey: "position")
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
    func errorBorderAnimation() {
        let baseColor = layer.borderColor
        
        let animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = baseColor
        animation.toValue = UIColor.vkRed.cgColor
        animation.duration = 0.1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        let animation1 = CABasicAnimation(keyPath: "borderColor")
        animation1.fromValue = UIColor.vkRed.cgColor
        animation1.toValue = baseColor
        animation1.beginTime = 1.1
        animation1.duration = 0.1
        animation1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animation, animation1]
        animationGroup.duration = 1.2
        
        layer.borderColor = baseColor
        layer.add(animationGroup, forKey: "borderColorAnimation")
    }
}
