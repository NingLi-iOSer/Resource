//
//  LNSwipeAnimator.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNSwipeAnimator {
    
    var isRunning: Bool { get }
    
    func addAnimations(_ animation: @escaping () -> Void)
    
    func addCompletion(_ completion: @escaping (Bool) -> Void)
    
    func startAnimation()
    
    func startAnimation(afterDelay delay: TimeInterval)

    func stopAnimation(_ withoutFinishing: Bool)
}

extension UIViewPropertyAnimator: LNSwipeAnimator {
    func addCompletion(_ completion: @escaping (Bool) -> Void) {
        addCompletion { (position) in
            completion(position == .end)
        }
    }
}

class UIViewSpringAnimator: LNSwipeAnimator {
    var isRunning: Bool = false
    
    let duration: TimeInterval
    let damping: CGFloat
    let velocity: CGFloat
    
    var animations: (() -> Void)?
    var completion: ((Bool) -> Void)?
    
    required init(duration: TimeInterval,
                  damping: CGFloat,
                  initialVelocity velocity: CGFloat = 0) {
        self.duration = duration
        self.damping = damping
        self.velocity = velocity
    }
    
    func addAnimations(_ animation: @escaping () -> Void) {
        self.animations = animation
    }
    
    func addCompletion(_ completion: @escaping (Bool) -> Void) {
        self.completion = { [weak self] finished in
            guard self?.isRunning == true else {
                return
            }
            
            self?.isRunning = false
            self?.animations = nil
            self?.completion = nil
            
            completion(finished)
        }
    }
    
    func startAnimation() {
        startAnimation(afterDelay: 0)
    }
    
    func startAnimation(afterDelay delay: TimeInterval) {
        guard let animations = animations else {
            return
        }
        isRunning = true
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       options: [.curveEaseInOut, .allowUserInteraction],
                       animations: animations,
                       completion: completion)
    }
    
    func stopAnimation(_ withoutFinishing: Bool) {
        isRunning = false
    }
}
