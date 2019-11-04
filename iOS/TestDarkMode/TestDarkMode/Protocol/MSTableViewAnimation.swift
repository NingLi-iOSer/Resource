//
//  MSTableViewAnimation.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

private let kTipViewTag: Int = 101

protocol MSViewAnimation {
    /// 显示下拉刷新成功提示
    ///
    /// - Parameter tip: 提示文本
    func showRefreshSuccessTip(tip: String)
}

extension MSViewAnimation where Self: UIScrollView {
    func showRefreshSuccessTip(tip: String) {
        guard let superV = superview else {
            return
        }
        // 判断上一次提示是否已经移除
        if let tipView = superV.viewWithTag(kTipViewTag) {
            tipView.removeFromSuperview()
        }
        let height: CGFloat = 26
        let tipView: UIView? = UIView(frame: CGRect(x: 0, y: frame.minY - height, width: bounds.width, height: height))
        tipView?.tag = kTipViewTag
        tipView?.backgroundColor = UIColor.hexColor(hex: 0x4398F6, alpha: 0.75)
        superV.insertSubview(tipView!, aboveSubview: self)
        
        let tipLabel = UILabel.ms_text(tip, textColor: UIColor.white, fontSize: 12)
        tipView!.addSubview(tipLabel)
        tipLabel.frame = CGRect(x: 25, y: 5, width: kScreenWidth - 50, height: 17)
        
        UIView.animate(withDuration: kAnimationDuration, animations: {
            tipView!.frame.origin.y += height
        }) { (_) in
            UIView.animate(withDuration: kAnimationDuration, delay: 1.5, options: [], animations: {
                tipView?.alpha = 0
            }, completion: { (_) in
                tipView?.removeFromSuperview()
            })
        }
    }
}
