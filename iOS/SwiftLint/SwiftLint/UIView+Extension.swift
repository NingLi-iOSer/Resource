//
//  UIView+Extension.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/6/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        set {
            layer.shadowColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.white.cgColor)
        }
    }
    
    @IBInspectable var shadowOffsetX: CGFloat {
        set {
            layer.shadowOffset.width = newValue
        }
        get {
            return layer.shadowOffset.width
        }
    }
    
    @IBInspectable var shadowOffsetY: CGFloat {
        set {
            layer.shadowOffset.height = newValue
        }
        get {
            return layer.shadowOffset.height
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /// 截图
    func shot(in rect: CGRect) -> UIImage? {
        guard bounds.width > 0 && bounds.height > 0 else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        
        for window in UIApplication.shared.windows {
            ctx.saveGState()
            ctx.translateBy(x: window.center.x, y: window.center.y)
            ctx.concatenate(window.transform)
            ctx.translateBy(x: -window.bounds.width * window.layer.anchorPoint.x, y: -window.bounds.height * window.layer.anchorPoint.y)
            window.layer.render(in: ctx)
            ctx.restoreGState()
        }
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        let cgImage = image.cgImage!
        
        let scale = UIScreen.main.scale
        let imageRect = CGRect(x: rect.origin.x * scale,
                               y: rect.origin.y * scale,
                               width: rect.width * scale,
                               height: rect.height * scale)
        
        let rectImage = cgImage.cropping(to: imageRect)!
        let result = UIImage(cgImage: rectImage)

        return result
    }
}
