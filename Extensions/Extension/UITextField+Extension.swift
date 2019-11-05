//
//  UITextField+Extension.swift
//  FactoryManageSystem
//
//  Created by 刘晓明@亚洲红 on 2017/9/22.
//  Copyright © 2017年 Yazhouhong. All rights reserved.
//

import UIKit

extension UITextField {
    
    var ln_realText: String? {
        return text?.ln_realString()
    }
    
    /// 右缩进
    @IBInspectable var rightInset: CGFloat {
        set {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 1))
            rightViewMode = .always
        }
        get {
            return rightView?.bounds.width ?? 0
        }
    }
    
    /// 左缩进
    @IBInspectable var leftInset: CGFloat {
        set {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 1))
            leftViewMode = .always
        }
        get {
            return leftView?.bounds.width ?? 0
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        let attrM = NSMutableAttributedString(string: placeholder ?? "")
        attrM.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.hexColor(hex: 0x999999),
                             NSAttributedString.Key.font: font!],
                            range: NSMakeRange(0, placeholder?.count ?? 0))
        attributedPlaceholder = attrM.copy() as? NSAttributedString
    }
}
