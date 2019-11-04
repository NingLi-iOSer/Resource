//
//  LNHeaderView.swift
//  Test
//
//  Created by Ning Li on 2019/9/29.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class LNHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    class func instance(title: String?, isFirst: Bool) -> LNHeaderView {
        let v = UINib(nibName: "LNHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! LNHeaderView
        v.setupUI(title: title, isFirst: isFirst)
        return v
    }
    
    private func setupUI(title: String?, isFirst: Bool) {
        
        titleLabel.text = title
        
        if isFirst {
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.white.cgColor
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: -12, width: UIScreen.main.bounds.width, height: 24), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
            shapeLayer.path = path.cgPath
            layer.insertSublayer(shapeLayer, at: 0)
        }
    }
}
