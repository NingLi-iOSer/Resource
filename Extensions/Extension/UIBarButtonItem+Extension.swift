//
//  UIBarButtonItem.swift
//  ManagementSystem
//
//  Created by Apple on 2018/3/26.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建图像 Item
    ///
    /// - Parameters:
    ///   - image: 默认图像
    ///   - highlightedImage: 高亮图像
    ///   - target: target
    ///   - action: action
    class func imageItem(image: UIImage, highlightedImage: UIImage?, target: Any?, action: Selector, isLeft: Bool = false) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(image, for: .normal)
        if highlightedImage == nil {
            button.setImage(image, for: .highlighted)
        } else {
            button.setImage(highlightedImage, for: .highlighted)
        }
        button.addTarget(target, action: action, for: .touchUpInside)

        button.sizeToFit()
        button.bounds.size.width += 10
        button.bounds.size.height += 10
        if isLeft {
            button.imageEdgeInsets.left = -10
        } else {
            button.imageEdgeInsets.right = -10
        }
        let item = UIBarButtonItem(customView: button)
        return item
    }
    
    /// 创建文本 Item
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - target: target
    ///   - action: action
    ///   - textColor: 字体颜色
    ///   - fontSize: 字体大小
    class func textItem(text: String, target: Any?, action: Selector, textColor: UIColor = UIColor.black, fontSize: CGFloat, weight: UIFont.Weight = .medium) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        button.sizeToFit()
        
        let item = UIBarButtonItem(customView: button)
        return item
    }
}
