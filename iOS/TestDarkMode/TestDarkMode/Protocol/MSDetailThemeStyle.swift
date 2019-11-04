//
//  MSDetailThemeStyle.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

/// 详情控制器主题样式
protocol MSDetailThemeStyle: MSThemeStyle {
}

extension MSDetailThemeStyle where Self: MSBaseController {

    func settingThemeStyle(title: String?) {
        statusBarStyle = .lightContent
        navItem.title = title
        navItem.leftBarButtonItem = backItemWhite
        navBar.backgroundColor = UIColor.clear
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        settingStatusBarBgView()
    }
    
    /// 设置状态栏背景视图
    private func settingStatusBarBgView() {
        let bgLayer = CAGradientLayer()
        bgLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarHeight)
        bgLayer.colors = [UIColor.hexColor(hex: 0x4398F6).cgColor,
                          UIColor.hexColor(hex: 0x2777C8).cgColor]
        bgLayer.startPoint = CGPoint(x: 0, y: 0.5)
        bgLayer.endPoint = CGPoint(x: 1, y: 0.5)
        view.layer.insertSublayer(bgLayer, at: 0)
    }
}
