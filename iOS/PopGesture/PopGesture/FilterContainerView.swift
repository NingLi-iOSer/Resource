//
//  FilterContainerView.swift
//  PopGesture
//
//  Created by Ning Li on 2019/3/30.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

private let kFilterContainerViewTag = "FilterContainerView".hashValue

class FilterContainerView: UIView {
    
    private weak var contentView: UIView?

    class func show(contentView: UIView) {
        let container = FilterContainerView()
        container.tag = kFilterContainerViewTag
        container.addSubview(contentView)
        container.contentView = contentView
        contentView.frame = CGRect(x: UIScreen.main.bounds.width,
                                   y: 0,
                                   width: UIScreen.main.bounds.width - 80,
                                   height: UIScreen.main.bounds.height)
        container.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        UIApplication.shared.keyWindow?.addSubview(container)
        container.frame = UIScreen.main.bounds
        container.alpha = 0
        UIView.animate(withDuration: 0.25) {
            container.alpha = 1
            contentView.frame.origin.x = 100
        }
    }
    
    class func dismiss() {
        guard let container = UIApplication.shared.keyWindow?.viewWithTag(kFilterContainerViewTag) as? FilterContainerView else {
            return
        }
        container.dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.contentView?.frame.origin.x = UIScreen.main.bounds.width
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let point = touches.first?.location(in: self),
            let contentView = contentView
            else {
                return
        }
        if !contentView.frame.contains(point) {
            dismiss()
        }
    }
}
