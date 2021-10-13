//
//  CustomPopupAnimation.swift
//  Xpert
//
//  Created by Darius on 23/08/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit


class CustomPopupAnimation: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var duration = 0.3
    var presenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        var popup : CenterPopupViewController
        
        if presenting == true {
            popup = transitionContext.viewController(forKey: .to)! as! CenterPopupViewController
            container.addSubview(transitionContext.viewController(forKey: .to)!.view)
        } else {
            popup = transitionContext.viewController(forKey: .from)! as! CenterPopupViewController
        }
        
        popup.backgroundView.alpha = presenting == true ? 0 : 1
        popup.contentView.transform = CGAffineTransform(translationX: 0, y: presenting == true ? 50 : 0)
        popup.contentView.alpha = presenting == true ? 0 : 1
        
        UIView.animate(withDuration: duration) {
            popup.backgroundView.alpha = self.presenting == true ? 1 : 0
        }
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: UIView.AnimationOptions.curveEaseOut, animations: {
            popup.contentView.transform = self.presenting == true ? .identity : CGAffineTransform(translationX: 0, y: 50)
            popup.contentView.alpha = self.presenting == true ? 1 : 0
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presenting = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
}
