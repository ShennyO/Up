//
//  NewTaskVCAnimator.swift
//  Up
//
//  Created by Sunny Ouyang on 5/18/19.
//

import UIKit

class NewTaskVCAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let toViewController = transitionContext.viewController(forKey: .to) as! NewTaskViewController
        let toVCView = toViewController.view
        let toView = toViewController.grayView
        let slidingView = toViewController.containerView
        toVCView?.alpha = 1
        toView.alpha = 0
        slidingView.center = CGPoint(x: widthScaleFactor(distance: 212), y: heightScaleFactor(distance: 1104))
        containerView.addSubview(toVCView!)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        slidingView.center = CGPoint(x: widthScaleFactor(distance: 212), y: heightScaleFactor(distance: 372))
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
            toView.alpha = 1
        }, completion: nil)
        
    }
    
    deinit {
        print("Animator deinitialized")
    }
    
}
