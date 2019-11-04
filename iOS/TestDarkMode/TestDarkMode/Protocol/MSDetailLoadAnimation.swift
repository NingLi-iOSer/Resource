//
//  MSDetailLoadAnimation.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/12/15.
//  Copyright © 2018 Apple. All rights reserved.
//

/// 详情加载动画协议
protocol MSDetailLoadAnimation {
    
    /// 显示加载动画
    func showLoadAnim(hasNavBar: Bool, reload: (() -> Void)?)
    
    /// 隐藏加载动画
    func hiddenLoadAnim()
    
    /// 显示加载失败页
    func showLoadFailurePage(tip: String?)
}

extension MSDetailLoadAnimation where Self: UIViewController {
    
    /// 显示加载动画
    func showLoadAnim(hasNavBar: Bool, reload: (() -> Void)?) {
        MSLoadAnimation.show(inView: view, hasNavBar: hasNavBar, reload: reload)
    }
    
    /// 隐藏加载动画
    func hiddenLoadAnim() {
        let loadAnim = view.viewWithTag(loadAnimTag) as? MSLoadAnimation
        loadAnim?.hiddenAnimation()
    }
    
    /// 显示加载失败页
    func showLoadFailurePage(tip: String?) {
        let loadAnim = view.viewWithTag(loadAnimTag) as? MSLoadAnimation
        loadAnim?.showLoadFailurePage(tip: tip)
    }
}
