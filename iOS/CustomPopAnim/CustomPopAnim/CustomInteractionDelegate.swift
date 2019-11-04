//
//  CustomInteractionDelegate.swift
//  CustomPopAnim
//
//  Created by Ning Li on 2019/7/18.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class CustomInteractionDelegate: UIPercentDrivenInteractiveTransition {

    static let shared = CustomInteractionDelegate()
    
    public weak var delegate: UINavigationControllerDelegate?
    public var navigation: UINavigationController?
    
    private var isPop: Bool = false
    private var isInteraction: Bool = false
}

extension CustomInteractionDelegate {
    @objc func edgePanAction(_ pan: UIScreenEdgePanGestureRecognizer) {
        let rate = pan.translation(in: UIApplication.shared.keyWindow!).x / UIScreen.main.bounds.width
        let velocity = pan.velocity(in: UIApplication.shared.keyWindow!).x
        switch pan.state {
        case .began:
            isInteraction = true
            navigation?.popViewController(animated: true)
        case .changed:
            isInteraction = false
            update(rate)
        case .ended:
            isInteraction = false
            if rate >= 0.4 {
                finish()
            } else {
                if velocity > 1000 {
                    finish()
                } else {
                    cancel()
                }
            }
        default:
            isInteraction = false
            cancel()
        }
    }
}

extension CustomInteractionDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteraction ? isPop ? self : nil : nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let anim: UIViewControllerAnimatedTransitioning?
        if operation == .push {
            isPop = false
            anim = CustomAnimationBegin()
        } else if operation == .pop {
            isPop = true
            anim = CustomAnimationEnd()
        } else {
            anim = nil
        }
        return anim
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if delegate != nil && !(delegate?.description.elementsEqual(self.description) ?? true) && (delegate?.responds(to: #selector(navigationController(_:willShow:animated:))) ?? false) {
            delegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if delegate != nil && !(delegate?.description.elementsEqual(self.description) ?? true) && (delegate?.responds(to: #selector(navigationController(_:didShow:animated:))) ?? false) {
            delegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
        }
    }
}
