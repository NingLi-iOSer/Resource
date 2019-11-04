//
//  LNSwipeExpansionStyle.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

public struct LNSwipeExpansionStyle {
    public static var selection: LNSwipeExpansionStyle {
        return LNSwipeExpansionStyle(target: .percentage(0.5),
                                     elasticOverscroll: true,
                                     completionAnimation: .bounce)
    }
    
    public static var destructive: LNSwipeExpansionStyle {
        return .destructive(automaticallyDelete: true, timing: .with)
    }
    
    public static var destructiveAfterFill: LNSwipeExpansionStyle {
        return .destructive(automaticallyDelete: true, timing: .after)
    }
    
    public static var fill: LNSwipeExpansionStyle {
        return LNSwipeExpansionStyle(target: .edgeInset(30),
                                     additionalTriggers: [.overscroll(30)],
                                     completionAnimation: .fill(.manual(timing: .after)))
    }
    
    public static func destructive(automaticallyDelete: Bool, timing: FillOptions.HandlerInvocationTiming = .with) -> LNSwipeExpansionStyle {
        return LNSwipeExpansionStyle(target: .edgeInset(30),
                                     additionalTriggers: [.touchThreshold(0.8)],
                                     completionAnimation: .fill(automaticallyDelete ? .automatic(.delete, timing: timing) : .manual(timing: timing)))
    }
    
    public let target: Target
    
    public let additionalTriggers: [Trigger]
    
    public let elasticOverscroll: Bool
    
    public let completionAnimation: CompletionAnimation
    
    public var minimumTargetOverscroll: CGFloat = 20
    
    public var targetOverscrollElasticity: CGFloat = 0.2
    
    var minimumExpansionTranslation: CGFloat = 0.8
    
    public init(target: Target, additionalTriggers: [Trigger] = [], elasticOverscroll: Bool = false, completionAnimation: CompletionAnimation) {
        self.target = target
        self.additionalTriggers = additionalTriggers
        self.elasticOverscroll = elasticOverscroll
        self.completionAnimation = completionAnimation
    }
    
    func shouldExoand(view: LNSwipeable, gesture: UIPanGestureRecognizer, in superview: UIView, withIn frame: CGRect? = nil) -> Bool {
        guard let actionsView = view.actionsView,
            let gestureView = gesture.view,
            abs(gesture.translation(in: gestureView).x) > minimumExpansionTranslation
            else {
                return false
        }
        
        let xDelta = floor(abs(frame?.minX ?? view.frame.minX))
        if xDelta <= actionsView.preferredWidth {
            return false
        } else if xDelta > targetOffset(for: view) {
            return true
        }
        
        let referenceFrame: CGRect = (frame != nil) ? view.frame : superview.bounds
        for trigger in additionalTriggers {
            if trigger.isTriggered(view: view, gesture: gesture, in: superview, referenceFrame: referenceFrame) {
                return true
            }
        }
        
        return false
    }
    
    func targetOffset(for view: LNSwipeable) -> CGFloat {
        return target.offset(for: view, minimnuOverscroll: minimumTargetOverscroll)
    }
}

extension LNSwipeExpansionStyle {
    public enum Target {
        case percentage(CGFloat)
        case edgeInset(CGFloat)
        
        func offset(for view: LNSwipeable, minimnuOverscroll: CGFloat) -> CGFloat {
            guard let actionsView = view.actionsView else {
                return .greatestFiniteMagnitude
            }
            
            let offset: CGFloat = {
                switch self {
                case .percentage(let value):
                    return view.frame.width * value
                case .edgeInset(let value):
                    return view.frame.width - value
                }
            }()
            
            return max(actionsView.preferredWidth + minimnuOverscroll, offset)
        }
    }
    
    public enum Trigger {
        case touchThreshold(CGFloat)
        
        case overscroll(CGFloat)
        
        func isTriggered(view: LNSwipeable, gesture: UIPanGestureRecognizer, in superview: UIView, referenceFrame: CGRect) -> Bool {
            guard let actionsView = view.actionsView else {
                return false
            }
            
            switch self {
            case .touchThreshold(let value):
                let location = gesture.location(in: superview).x - referenceFrame.origin.x
                let locationRatio = (referenceFrame.width - location) / referenceFrame.width
                return locationRatio > value
            case .overscroll(let value):
                return abs(view.frame.minX) > actionsView.preferredWidth + value
            }
        }
    }
    
    public enum CompletionAnimation {
        case fill(FillOptions)
        
        case bounce
    }
    
    public struct FillOptions {
        public enum HandlerInvocationTiming {
            case with
            
            case after
        }
        
        public static func automatic(_ style: LNExpansionFulfillmentStyle, timing: HandlerInvocationTiming) -> FillOptions {
            return FillOptions(autoFulFillmentStyle: style, timing: timing)
        }
        
        public static func manual(timing: HandlerInvocationTiming) -> FillOptions {
            return FillOptions(autoFulFillmentStyle: nil, timing: timing)
        }
        
        public let autoFulFillmentStyle: LNExpansionFulfillmentStyle?
        
        public let timing: HandlerInvocationTiming
    }
}

extension LNSwipeExpansionStyle.Target: Equatable {
    public static func ==(lhs: LNSwipeExpansionStyle.Target, rhs: LNSwipeExpansionStyle.Target) -> Bool {
        switch (lhs, rhs) {
        case (.percentage(let lhs), .percentage(let rhs)):
            return lhs == rhs
        case (.edgeInset(let lhs), .edgeInset(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension LNSwipeExpansionStyle.CompletionAnimation: Equatable {
    public static func ==(lhs: LNSwipeExpansionStyle.CompletionAnimation, rhs: LNSwipeExpansionStyle.CompletionAnimation) -> Bool {
        switch (lhs, rhs) {
        case (.fill, .fill):
            return true
        case (.bounce, .bounce):
            return true
        default:
            return false
        }
    }
}
