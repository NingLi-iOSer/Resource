//
//  NSLayoutConstraint+Extension.swift
//  ManagementSystem
//
//  Created by Ning Li on 2019/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func changeMultiplier(_ multi: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        let cons = NSLayoutConstraint(item: firstItem!,
                                      attribute: firstAttribute,
                                      relatedBy: relation,
                                      toItem: secondItem,
                                      attribute: secondAttribute,
                                      multiplier: multi,
                                      constant: constant)
        cons.priority = priority
        cons.shouldBeArchived = shouldBeArchived
        cons.identifier = identifier
        NSLayoutConstraint.activate([cons])
        return cons
    }
}
