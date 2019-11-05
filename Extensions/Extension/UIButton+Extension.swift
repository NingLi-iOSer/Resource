//
//  UIButton+Extension.swift
//  ManagementSystem
//
//  Created by Apple on 2018/3/27.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension UIButton {
    
    static let kButtonAction = UnsafeRawPointer(bitPattern: "kButtonAction".hashValue)!
    
    var ln_action: (() -> Void)? {
        set {
            objc_setAssociatedObject(self, UIButton.kButtonAction, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.kButtonAction) as? (() -> Void)
        }
    }
    
    /// 创建文本按钮
    class func ms_textButton(text: String?, textColor: UIColor, backgroundColor: UIColor?, fontSize: CGFloat = 16, target: Any?, action: Selector) -> Self {
        let button = self.init()
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        return button
    }
    
    /// 创建系统样式按钮
    class func systemButton(text: String?, textColor: UIColor, backgroundColor: UIColor?, fontSize: CGFloat = 16, action: (() -> Void)?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        button.ln_action = action
        button.addTarget(button, action: #selector(button.actionClosure), for: .touchUpInside)
        button.sizeToFit()
        return button
    }
    
    convenience init(text: String?, textColor: UIColor, backgroundColor: UIColor?, fontSize: CGFloat = 16, action: (() -> Void)?) {
        self.init()
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        self.ln_action = action
        self.addTarget(self, action: #selector(actionClosure), for: .touchUpInside)
        self.sizeToFit()
    }
    
    /// 创建图像按钮
    class func ms_imageButton(image: UIImage, highlightedImage: UIImage?, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.setImage(highlightedImage ?? image, for: .highlighted)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        return button
    }
    
    /// 添加背景渐变
    func addGradientBackground(colors: [CGColor], size: CGSize, cornerRadius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(origin: CGPoint(), size: size)
        gradientLayer.cornerRadius = cornerRadius
        
        layer.addSublayer(gradientLayer)
    }
    
    /// 响应边界
    var hitEdgeInsets: UIEdgeInsets {
        set {
            objc_setAssociatedObject(self, "hitEdgeInsets", newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return (objc_getAssociatedObject(self, "hitEdgeInsets") as? UIEdgeInsets) ?? UIEdgeInsets()
        }
    }
    
    @objc private func actionClosure() {
        ln_action?()
    }
    
    /// 设置图片
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - placeholder: 加载占位图片
    ///   - failure: 加载失败图片
    ///   - empty: 无图占位
    func ms_setImage(with URLString: String?, placeholder: UIImage, failure: UIImage?, empty: UIImage?) {
        guard let URLString = URLString,
            let imageURL = URL(string: URLString)
            else {
                setImage(empty ?? placeholder, for: .normal)
                return
        }
        let size = bounds.size
        sd_setImage(with: imageURL, for: .normal, placeholderImage: placeholder, options: []) { [weak self] (image, _, _, _) in
            if let image = image {
                self?.setImage(image.roundCornerImage(size: size, cornerRadius: nil), for: .normal)
            } else {
                self?.setImage(failure, for: .normal)
            }
        }
    }
}
