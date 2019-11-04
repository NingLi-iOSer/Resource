//
//  LNSwipeActionTransitioning.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/26.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNSwipeActionTransitioning {
    func didTransition(with context: LNSwipeActionTransitioningContext)
}

struct LNSwipeActionTransitioningContext {
    
    public let actionIdentifier: String?
    
    public let button: UIButton
    
    public let newPercentVisible: CGFloat
    
    public let oldPercentVisible: CGFloat

    public let wrapperView: UIView
    
    internal init(actionIdentifier: String?, button: UIButton, newPercentVisible: CGFloat, oldPercentVisible: CGFloat, wrapperView: UIView) {
        self.actionIdentifier = actionIdentifier
        self.button = button
        self.newPercentVisible = newPercentVisible
        self.oldPercentVisible = oldPercentVisible
        self.wrapperView = wrapperView
    }
    
    public func setBackgroundColor(_ color: UIColor?) {
        wrapperView.backgroundColor = color
    }
}

struct LNScaleTransition {
    
    public static var `default`: LNScaleTransition {
        return LNScaleTransition()
    }
    
    public let duration: Double
    
    public let initialScale: CGFloat
    
    public let threshold: CGFloat
    
    init(duration: Double = 0.15, initialScale: CGFloat = 0.8, threshold: CGFloat = 0.5) {
        self.duration = duration
        self.initialScale = initialScale
        self.threshold = threshold
    }
}

extension LNScaleTransition: LNSwipeActionTransitioning {
    func didTransition(with context: LNSwipeActionTransitioningContext) {
        if context.oldPercentVisible == 0 {
            context.button.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
        }
        
        if context.oldPercentVisible < threshold && context.newPercentVisible >= threshold {
            UIView.animate(withDuration: duration) {
                context.button.transform = .identity
            }
        } else if context.oldPercentVisible >= threshold && context.newPercentVisible < threshold {
            UIView.animate(withDuration: duration) {
                context.button.transform = CGAffineTransform(scaleX: self.initialScale, y: self.initialScale)
            }
        }
    }
}
