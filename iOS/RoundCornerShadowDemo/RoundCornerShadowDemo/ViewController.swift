//
//  ViewController.swift
//  RoundCornerShadowDemo
//
//  Created by Ning Li on 2019/9/10.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var roundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingRoundCorner()
        settingShadow()
    }

    /// 设置圆角
    private func settingRoundCorner() {
        let roundLayer = CAShapeLayer()
        roundLayer.fillColor = UIColor.red.cgColor
        let rect = roundView.bounds
        roundLayer.frame = rect
        let roundPath = UIBezierPath(roundedRect: rect, cornerRadius: 20)
        roundLayer.path = roundPath.cgPath
        roundView.layer.mask = roundLayer
        roundView.layer.addSublayer(roundLayer)
    }
    
    /// 设置阴影
    private func settingShadow() {
        let rect = roundView.bounds
        roundView.layer.shadowColor = UIColor.black.cgColor
        roundView.layer.shadowRadius = 20
        roundView.layer.shadowOpacity = 0.69
        let path = UIBezierPath(rect: rect.offsetBy(dx: 5, dy: 5))
        roundView.layer.shadowPath = path.cgPath
    }
}

