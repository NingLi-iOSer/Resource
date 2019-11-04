//
//  UIButton+Extension.swift
//  SwiftLint
//
//  Created by Ning Li on 2019/4/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

extension UIButton {
    
    func addGradientBackground(colors: [CGColor], size: CGSize, cornerRadius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = CGRect(origin: CGPoint(), size: size)
        gradientLayer.cornerRadius = cornerRadius
        
        layer.addSublayer(gradientLayer)
    }
}
