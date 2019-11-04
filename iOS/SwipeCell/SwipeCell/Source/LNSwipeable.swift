//
//  LNSwipeable.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNSwipeable {
    var state: LNSwipeState { get set }
    
    var actionsView: LNSwipeActionsView? { get set }
    
    var frame: CGRect { get }
    
    var scrollView: UIScrollView? { get }
    
    var indexPath: IndexPath? { get }
    
    var panGestureRecognizer: UIGestureRecognizer { get }
}

extension LNSwipeCell: LNSwipeable { }

enum LNSwipeState: Int {
    case center = 10
    case left
    case right
    case dragging
    case animationToCenter
    
    var isActive: Bool {
        return self != .center
    }
}
