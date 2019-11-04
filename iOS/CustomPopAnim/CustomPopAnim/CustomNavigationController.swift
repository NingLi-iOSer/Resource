//
//  CustomNavigationController.swift
//  CustomPopAnim
//
//  Created by Ning Li on 2019/7/18.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    private var interactionDelegate: CustomInteractionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = self
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UINavigationControllerDelegate, UIGestureRecognizerDelegate
extension CustomNavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.isEnabled = true
        }
        if children.count == 1 {
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
}

extension UINavigationController {
    
    static let kInteractionDelegate = UnsafeRawPointer(bitPattern: "kInteractionDelegate".hashValue)!
    
    private var interactionDelegate: CustomInteractionDelegate? {
        set {
            objc_setAssociatedObject(self, UINavigationController.kInteractionDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UINavigationController.kInteractionDelegate) as? CustomInteractionDelegate
        }
    }
    
    func ln_pushViewController(_ viewController: UIViewController) {
        interactionDelegate = CustomInteractionDelegate.shared
        interactionDelegate?.navigation = self
        let edgePan = UIScreenEdgePanGestureRecognizer(target: interactionDelegate, action: #selector(interactionDelegate?.edgePanAction(_:)))
        edgePan.edges = UIRectEdge.left
        viewController.view.addGestureRecognizer(edgePan)
        if !(delegate?.description.elementsEqual(interactionDelegate?.description ?? "") ?? false) {
            if delegate == nil {
                interactionDelegate?.delegate = nil
            }
            delegate = interactionDelegate
        }
        self.pushViewController(viewController, animated: true)
    }
}
