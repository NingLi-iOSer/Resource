//
//  LNSwipeAction.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

public enum LNExpansionFulfillmentStyle {
    case delete
    
    case reset
}

public enum LNSwipeActionStyle: Int {
    case `default`
    
    case destructive
}

class LNSwipeAction: NSObject {
    
    public var identifier: String?
    
    public var title: String?
    
    public var style: LNSwipeActionStyle
    
    public var transitionDelegate: LNSwipeActionTransitioning?
    
    public var font: UIFont?
    
    public var textColor: UIColor?
    
    public var highlightedTextColor: UIColor?
    
    public var image: UIImage?
    
    public var highlightedImage: UIImage?
    
    public var handler: ((LNSwipeAction, IndexPath) -> Void)?
    
    public var backgroundColor: UIColor?
    
    public var highlightedBackgroundColor: UIColor?
    
    public var backgroundEffect: UIVisualEffect?
    
    public var hidesWhenSelected = false
    
    internal var completionHandler: ((LNExpansionFulfillmentStyle) -> Void)?
    
    public init(style: LNSwipeActionStyle, title: String?, handler: ((LNSwipeAction, IndexPath) -> Void)?) {
        self.style = style
        self.title = title
        self.handler = handler
    }
    
    public func fulFill(with style: LNExpansionFulfillmentStyle) {
        completionHandler?(style)
    }
}

internal extension LNSwipeAction {
    var hasBackgroundColor: Bool {
        if backgroundColor != .clear && backgroundEffect == nil {
            return true
        } else {
            return false
        }
    }
}
