//
//  MSBasicAnimation.swift
//  LoadAnim
//
//  Created by Ning Li on 2018/12/13.
//  Copyright © 2018 Ning Li. All rights reserved.
//

import UIKit

protocol MSBasicAnimationDelegate: class {
    func animationDidStop(_ anim: CAAnimation)
}

extension MSBasicAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation) { }
}

class MSBasicAnimation: CABasicAnimation {
    
    weak var animDelegate: MSBasicAnimationDelegate? {
        didSet {
            delegate = self
        }
    }
}

// MARK: - CAAnimationDelegate
extension MSBasicAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animDelegate?.animationDidStop(anim)
    }
}
