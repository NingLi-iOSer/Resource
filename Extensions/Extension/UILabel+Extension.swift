//
//  UILabel+Extension.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - textColor: 文本颜色
    ///   - fontSize: 字体大小
    class func ms_text(_ text: String?, textColor: UIColor, fontSize: CGFloat) -> UILabel {
        let label = UILabel.ms_text(text, textColor: textColor, font: UIFont.systemFont(ofSize: fontSize))
        return label
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - textColor: 文本颜色
    ///   - fontSize: 字体大小
    class func ms_text(_ text: String?, textColor: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        return label
    }

    /// 设置数字和文字属性文本
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - filterCharacters: 需要过滤的字符
    ///   - numberColor: 数字颜色
    ///   - textColor: 文字颜色
    ///   - fontSize: 字体大小
    func ms_numberTextAttr(text: String?, filterCharacters: [String]?, numberColor: UIColor, textColor: UIColor, numberWeight: UIFont.Weight = .medium, textWeight: UIFont.Weight = .regular) {
        guard let string = text else {
            return
        }
        let characters = (filterCharacters ?? []) + [".", ","]
        let attrM = NSMutableAttributedString(string: string)
        
        let fontSize = font.pointSize
        // 遍历字符串
        for (index, char) in string.enumerated() {
            let ch = String(char)
            let scan: Scanner = Scanner(string: ch)
            
            var val:Int = 0
            
            // 判断是否是数字
            if scan.scanInt(&val) || characters.contains(ch) {
                let range = NSMakeRange(index, 1)
                attrM.addAttributes([NSAttributedString.Key.foregroundColor: numberColor,
                                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: numberWeight)],
                                    range: range)
            } else {
                let range = NSMakeRange(index, 1)
                attrM.addAttributes([NSAttributedString.Key.foregroundColor: textColor,
                                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: textWeight)],
                                    range: range)
            }
        }
        
        attributedText = attrM.copy() as? NSAttributedString
    }
}
