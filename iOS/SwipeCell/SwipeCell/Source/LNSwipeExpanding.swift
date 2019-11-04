//
//  LNSwipeExpanding.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNSwipeExpanding {
    
    func animationTimingParameters(buttons: [UIButton], expanding: Bool) -> LNSwipeExpansionAnimationTimingParameters
    
    func actionButton(_ button: UIButton, didChange expanding: Bool, otherActionButtons: [UIButton])
}

struct LNSwipeExpansionAnimationTimingParameters {
    
    public static var `default`: LNSwipeExpansionAnimationTimingParameters {
        return LNSwipeExpansionAnimationTimingParameters()
    }
    
    public var duration: Double
    
    public var delay: Double
    
    public init(duration: Double = 0.6, delay: Double = 0) {
        self.duration = duration
        self.delay = delay
    }
}

struct LNScaleAndAlphaExpansion {
    
    public static var `default`: LNScaleAndAlphaExpansion {
        return LNScaleAndAlphaExpansion()
    }
    
    public let duration: Double
    
    public let scale: CGFloat
    
    public let interButtonDelay: Double
    
    public init(duration: Double = 0.15, scale: CGFloat = 0.8, interButtonDelay: Double = 0.1) {
        self.duration = duration
        self.scale = scale
        self.interButtonDelay = interButtonDelay
    }
}

extension LNScaleAndAlphaExpansion: LNSwipeExpanding {
    func animationTimingParameters(buttons: [UIButton], expanding: Bool) -> LNSwipeExpansionAnimationTimingParameters {
        var timingParameters = LNSwipeExpansionAnimationTimingParameters.default
        if expanding {
            timingParameters.delay = interButtonDelay
        } else {
            timingParameters.delay = 0
        }
        return timingParameters
    }
    
    func actionButton(_ button: UIButton, didChange expanding: Bool, otherActionButtons: [UIButton]) {
        let buttons = expanding ? otherActionButtons : otherActionButtons.reversed()
        buttons.enumerated().forEach { (index, button) in
            let delay = interButtonDelay * Double(expanding ? index : index + 1)
            UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
                if expanding {
                    button.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
                    button.alpha = 0.0
                } else {
                    button.transform = .identity
                    button.alpha = 1.0
                }
            }, completion: nil)
        }
    }
}
