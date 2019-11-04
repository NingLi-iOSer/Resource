//
//  LNSwipeAccessibilityCustomAction.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/28.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class LNSwipeAccessibilityCustomAction: UIAccessibilityCustomAction {
    let action: LNSwipeAction
    let indexPath: IndexPath
    
    init?(action: LNSwipeAction, indexPath: IndexPath, target: Any, selector: Selector) {
        self.action = action
        self.indexPath = indexPath
        
        let name = action.accessibilityLabel ?? action.title ?? action.image?.accessibilityIdentifier ?? nil
        
        if let name = name {
            super.init(name: name, target: target, selector: selector)
        } else {
            return nil
        }
    }
}
