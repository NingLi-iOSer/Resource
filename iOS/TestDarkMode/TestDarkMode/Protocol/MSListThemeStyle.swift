//
//  MSListThemeStyle.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

/// 列表控制器主题样式
protocol MSListThemeStyle: MSThemeStyle {
    /// 新建按钮
    var newItem: UIBarButtonItem { get }
    
    /// 新建按钮
    var newItemWhite: UIBarButtonItem { get }
}

extension MSListThemeStyle where Self: MSBaseController {
    var newItem: UIBarButtonItem {
        let new = UIBarButtonItem.imageItem(image: #imageLiteral(resourceName: "nav_create"), highlightedImage: nil, target: self, action: #selector(createNew))
        return new
    }
    
    var newItemWhite: UIBarButtonItem {
        let new = UIBarButtonItem.imageItem(image: #imageLiteral(resourceName: "nav_create_white"), highlightedImage: nil, target: self, action: #selector(createNew))
        return new
    }
    
    func settingThemeStyle(title: String?) {
        statusBarStyle = .lightContent
        navItem.title = title
        navItem.leftBarButtonItem = backItemWhite
        navItem.rightBarButtonItem = newItemWhite
        navBar.backgroundColor = UIColor.clear
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        settingStatusBarBgView()
    }
    
    /// 设置状态栏背景视图
    private func settingStatusBarBgView() {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarHeight))
        let bgLayer = CAGradientLayer()
        bgLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kNavigationBarHeight)
        bgLayer.colors = [UIColor.hexColor(hex: 0x4398F6).cgColor,
                          UIColor.hexColor(hex: 0x2777C8).cgColor]
        bgLayer.startPoint = CGPoint(x: 0, y: 0.5)
        bgLayer.endPoint = CGPoint(x: 1, y: 0.5)
        bgView.layer.addSublayer(bgLayer)
        view.insertSubview(bgView, belowSubview: navBar)
    }
}
