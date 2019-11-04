//
//  UIColor+Extension.swift
//  ManagementSystem
//
//  Created by Apple on 2018/3/23.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// 使用十六进制数字创建颜色
    class func hexColor(hex: uint, alpha: CGFloat = 1.0) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }

    // MARK: - 类方法对外提供随机色，alpha = 1
    class func randomColor() -> UIColor {
        
        return UIColor(red: (CGFloat(arc4random_uniform(255)) / CGFloat(255.0)), green: (CGFloat(arc4random_uniform(255)) / CGFloat(255.0)), blue: (CGFloat(arc4random_uniform(255)) / CGFloat(255.0)), alpha: 1.0)
    }
}
