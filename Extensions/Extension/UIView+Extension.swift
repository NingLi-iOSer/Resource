//
//  UIView+Extension.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/6/1.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UIView: MSViewPlaceholder {
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
    
    @IBInspectable var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
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
    
    /// 设置阴影路径
    ///
    /// - Parameters:
    ///   - rect: 路径坐标
    ///   - cornerRadius: 圆角半径
    func setShadowPath(rect: CGRect, cornerRadius: CGFloat = 0) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        layer.shadowPath = path.cgPath
    }
}

extension UIView: NibCreatable { }

// MARK: - 弹性动画
extension UIView {
    /// 弹性动画
    func singleDragable() {
        if superview != nil {
            removeAllDraggable()
            ln_playground = superview
            ln_damping = 0.4
            singleAnimator()
            singleAddPanGesture()
        }
    }
    
    private func removeAllDraggable() {
        if ln_panGesture != nil {
            removeGestureRecognizer(ln_panGesture!)
        }
        ln_playground = nil
        ln_panGesture = nil
        ln_animator = nil
        ln_snapBehavior = nil
        ln_attachmentBehavior = nil
        ln_centerPoint = CGPoint()
    }
    
    /// 添加仿真动画
    private func singleAnimator() {
        ln_animator = UIDynamicAnimator(referenceView: ln_playground!)
        singleUpdateSnapPoint()
    }
    
    private func singleUpdateSnapPoint() {
        ln_centerPoint = convert(CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5), to: ln_playground!)
        ln_snapBehavior = UISnapBehavior(item: self, snapTo: ln_centerPoint!)
        ln_snapBehavior?.damping = ln_damping!
    }
    
    /// 添加 pan 手势
    private func singleAddPanGesture() {
        ln_panGesture = UIPanGestureRecognizer(target: self, action: #selector(singlePanGesture(pan:)))
        addGestureRecognizer(ln_panGesture!)
    }
    
    @objc private func singlePanGesture(pan: UIPanGestureRecognizer) {
        let location = pan.location(in: ln_playground!)
        switch pan.state {
        case .began:
            if #available(iOS 10.0, *) {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
            singleUpdateSnapPoint()
            let offset = UIOffset(horizontal: location.x - ln_centerPoint!.x,
                                  vertical: location.y - ln_centerPoint!.y)
            ln_animator?.removeAllBehaviors()
            ln_attachmentBehavior = UIAttachmentBehavior(item: self, offsetFromCenter: offset, attachedToAnchor: location)
            ln_animator?.addBehavior(ln_attachmentBehavior!)
        case .changed:
            ln_attachmentBehavior?.anchorPoint = location
        case .ended, .cancelled, .failed:
            ln_animator?.addBehavior(ln_snapBehavior!)
            ln_animator?.removeBehavior(ln_attachmentBehavior!)
        default:
            break
        }
    }
    
    private var ln_playground: UIView? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kPlayground, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.kPlayground) as? UIView
        }
    }
    
    private var ln_animator: UIDynamicAnimator? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kAnimator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.kAnimator) as? UIDynamicAnimator
        }
    }
    
    private var ln_snapBehavior: UISnapBehavior? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kSnapBehavior, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.kSnapBehavior) as? UISnapBehavior
        }
    }
    
    private var ln_attachmentBehavior: UIAttachmentBehavior? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kAttachmentBehavior, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.kAttachmentBehavior) as? UIAttachmentBehavior
        }
    }
    
    private var ln_panGesture: UIPanGestureRecognizer? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kPanGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.kPanGesture) as? UIPanGestureRecognizer
        }
    }
    
    private var ln_centerPoint: CGPoint? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kCenterPoint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.kCenterPoint) as? CGPoint
        }
    }
    
    private var ln_damping: CGFloat? {
        set {
            objc_setAssociatedObject(self, RuntimeKey.kDamping, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, RuntimeKey.kDamping) as? CGFloat
        }
    }
}

struct RuntimeKey {
    static let kPlayground = UnsafeRawPointer(bitPattern: "kPlayground".hashValue)!
    static let kAnimator = UnsafeRawPointer(bitPattern: "kAnimator".hashValue)!
    static let kSnapBehavior = UnsafeRawPointer(bitPattern: "kSnapBehavior".hashValue)!
    static let kAttachmentBehavior = UnsafeRawPointer(bitPattern: "kAttachmentBehavior".hashValue)!
    static let kPanGesture = UnsafeRawPointer(bitPattern: "kPanGesture".hashValue)!
    static let kCenterPoint = UnsafeRawPointer(bitPattern: "kCenterPoint".hashValue)!
    static let kDamping = UnsafeRawPointer(bitPattern: "kDamping".hashValue)!
}
