//
//  LNSwipeOptions.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

typealias LNSwipeTableOptions = LNSwipeOptions

struct LNSwipeOptions {
    public var transitionStyle: LNSwipeTransitionStyle = .border
    
    public var expansionsStyle: LNSwipeExpansionStyle?
    
    public var exoansionDelegate: LNSwipeExpanding?
    
    public var backgroundColor: UIColor?
    
    public var maximumButtonWidth: CGFloat?
    
    public var minimumButtonWidth: CGFloat?
    
    public var buttonVerticalAlignment: LNSwipeVerticalAlignment = .centerFirstBaseline
    
    public var buttonPadding: CGFloat?
    
    public var buttonSpacing: CGFloat?
    
    public init() { }
}

enum LNSwipeTransitionStyle {
    case border
    case drag
    case reveal
}

enum LNSwipeVerticalAlignment {
    case centerFirstBaseline
    case center
}
