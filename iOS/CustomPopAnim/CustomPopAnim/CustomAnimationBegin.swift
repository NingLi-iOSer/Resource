//
//  CustomAnimationBegin.swift
//  CustomPopAnim
//
//  Created by Ning Li on 2019/7/18.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class CustomAnimationBegin: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let to = transitionContext.view(forKey: .to),
            let from = transitionContext.view(forKey: .from)
            else {
                return
        }
        to.frame = transitionContext.containerView.frame
        transitionContext.containerView.addSubview(to)
        
        to.frame.origin.x = to.bounds.width
        UIView.animate(withDuration: 0.3, animations: {
            to.frame.origin.x = 0
            from.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (_) in
            to.frame.origin.x = 0
            from.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
