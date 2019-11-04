//
//  CustomAnimationEnd.swift
//  CustomPopAnim
//
//  Created by Ning Li on 2019/7/19.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class CustomAnimationEnd: NSObject, UIViewControllerAnimatedTransitioning {

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
        transitionContext.containerView.bringSubviewToFront(from)
        
        to.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        let originalX = from.frame.origin.x
        UIView.animate(withDuration: 0.3, animations: {
            from.frame.origin.x = from.frame.width
            to.transform = .identity
        }) { (_) in
            from.frame.origin.x = originalX
            to.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
