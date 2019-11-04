//
//  MSThemeStyle.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

/// 控制器主题样式协议
protocol MSThemeStyle {
    /// 导航栏返回按钮
    var backItem: UIBarButtonItem { get }
    
    /// 返回按钮
    var backItemWhite: UIBarButtonItem { get }
    
    /// 设置控制器的主题样式
    ///
    /// - Parameter title: 导航栏标题
    func settingThemeStyle(title: String?)
    
    /// 返回上级控制器
    func backToPreviousVC()
}

extension MSThemeStyle where Self: MSBaseController {
    var backItem: UIBarButtonItem {
        let back = UIBarButtonItem.imageItem(image: #imageLiteral(resourceName: "nav_back"), highlightedImage: nil, target: self, action: #selector(backToPreviousVC), isLeft: true)
        return back
    }
    
    var backItemWhite: UIBarButtonItem {
        let back = UIBarButtonItem.imageItem(image: #imageLiteral(resourceName: "nav_back_white"), highlightedImage: nil, target: self, action: #selector(backToPreviousVC), isLeft: true)
        return back
    }

    func settingThemeStyle(title: String?) { }
}
