//
//  MSLoadAnimation.swift
//  LoadAnim
//
//  Created by Ning Li on 2018/12/13.
//  Copyright © 2018 Ning Li. All rights reserved.
//

import UIKit
import pop

private let kBackgroundColor = UIColor(red: 245 / 255.0, green: 247 / 255.0, blue: 249 / 255.0, alpha: 1)

class MSLoadAnimation: UIView {
    
    /// 圆
    private lazy var roundLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 131 / 255.0, green: 221 / 255.0, blue: 253 / 255.0, alpha: 1).cgColor
        return layer
    }()
    /// 小环
    private lazy var shortArcLineBGLayer: CALayer = {
        let bgLayer = CALayer()
        bgLayer.position = center
        bgLayer.bounds.size = CGSize(width: 44, height: 44)
        bgLayer.backgroundColor = kBackgroundColor.cgColor
        return bgLayer
    }()
    /// 大环
    private lazy var longArcLineBGLayer: CALayer = {
        let bgLayer = CALayer()
        bgLayer.position = center
        bgLayer.bounds.size = CGSize(width: 62, height: 62)
        bgLayer.backgroundColor = kBackgroundColor.cgColor
        return bgLayer
    }()

    /// 显示加载动画  - 添加到 window
    class func show() {
        let v = MSLoadAnimation(frame: UIScreen.main.bounds)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow!.addSubview(v)
        }
    }
    
    /// 显示加载动画 - 添加到视图上
    class func show(inView: UIView) {
        let v = MSLoadAnimation(frame: UIScreen.main.bounds)
        inView.addSubview(v)
    }
    
    /// 隐藏动画
    func hiddenAnimation() {
        UIView.animate(withDuration: , animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        settingUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置界面
private extension MSLoadAnimation {
    func settingUI() {
        backgroundColor = kBackgroundColor
        
        drawLongArcLine()
        drawShortArcLine()
        drawRound()
        roundAlphaReduceAnimation()
        roundScaleReduceAnimation()
        shortArcLineAnim()
        longArcLineAnim()
    }
    
    /// 绘制圆
    func drawRound() {
        roundLayer.position = center
        roundLayer.bounds.size = CGSize(width: 24, height: 24)
        roundLayer.cornerRadius = 12
        layer.addSublayer(roundLayer)
    }
    
    /// 小环
    func drawShortArcLine() {
        layer.addSublayer(shortArcLineBGLayer)
        let startAngle = -CGFloat.pi * 0.63
        let endAngle = startAngle + CGFloat.pi * 0.5
        let path = UIBezierPath(arcCenter: CGPoint(x: 22, y: 22), radius: 22, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let shortArcLine = CAShapeLayer()
        shortArcLine.strokeColor = UIColor(red: 145 / 255.0, green: 226 / 255.0, blue: 255 / 255.0, alpha: 1).cgColor
        shortArcLine.fillColor = UIColor(red: 245 / 255.0, green: 247 / 255.0, blue: 249 / 255.0, alpha: 1).cgColor
        shortArcLine.lineWidth = 2
        shortArcLine.lineCap = .round
        shortArcLine.path = path.cgPath
        shortArcLineBGLayer.addSublayer(shortArcLine)
    }
    
    /// 大环
    func drawLongArcLine() {
        layer.addSublayer(longArcLineBGLayer)
        let startAngle = -CGFloat.pi * 0.75
        let endAngle = startAngle + CGFloat.pi * 0.5
        let path = UIBezierPath(arcCenter: CGPoint(x: 31, y: 31), radius: 31, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let longArcLine = CAShapeLayer()
        longArcLine.strokeColor = UIColor(red: 173 / 255.0, green: 233 / 255.0, blue: 255 / 255.0, alpha: 1).cgColor
        longArcLine.fillColor = UIColor(red: 245 / 255.0, green: 247 / 255.0, blue: 249 / 255.0, alpha: 1).cgColor
        longArcLine.lineWidth = 2
        longArcLine.lineCap = .round
        longArcLine.path = path.cgPath
        longArcLineBGLayer.addSublayer(longArcLine)
    }
}

// MARK: - 动画
private extension MSLoadAnimation {
    /// 圆动画
    private func roundScaleReduceAnimation() {
        createAnimation(keyPath: kPOPLayerScaleX, fromValue: nil, toValue: 0.16, duration: 0.5, completionBlock: nil)
        createAnimation(keyPath: kPOPLayerScaleY, fromValue: nil, toValue: 0.16, duration: 0.5, completionBlock: nil)
    }
    
    private func roundAlphaReduceAnimation() {
        createAnimation(keyPath: kPOPLayerOpacity, fromValue: nil, toValue: 0.7, duration: 0.5) { [weak self] (_, _) in
            self?.roundAlphaIncreaseAnimation()
            self?.roundScaleIncreaseAnimation()
        }
    }
    
    private func roundScaleIncreaseAnimation() {
        createAnimation(keyPath: kPOPLayerScaleX, fromValue: nil, toValue: 1, duration: 0.5, completionBlock: nil)
        createAnimation(keyPath: kPOPLayerScaleY, fromValue: nil, toValue: 1, duration: 0.5, completionBlock: nil)
    }
    
    private func roundAlphaIncreaseAnimation() {
        createAnimation(keyPath: kPOPLayerOpacity, fromValue: nil, toValue: 1, duration: 0.5) { [weak self] (_, _) in
            self?.roundAlphaReduceAnimation()
            self?.roundScaleReduceAnimation()
        }
    }
    
    private func createAnimation(keyPath: String, fromValue: Any?, toValue: Any?, repeatCount: Int = 1, duration: CFTimeInterval, completionBlock: ((_ anim: POPAnimation?, _ finish: Bool) -> Void)?) {
        let anim = POPBasicAnimation(propertyNamed: keyPath)!
        anim.fromValue = fromValue
        anim.toValue = toValue
        anim.duration = duration
        anim.repeatCount = repeatCount
        anim.completionBlock = completionBlock
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        roundLayer.pop_add(anim, forKey: nil)
    }
    
    private func shortArcLineAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = CGFloat.pi * 2
        anim.duration = 1.8
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        anim.fillMode = .forwards
        shortArcLineBGLayer.add(anim, forKey: nil)
    }
    
    private func longArcLineAnim() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = CGFloat.pi * 2
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        anim.isRemovedOnCompletion = false
        anim.fillMode = .forwards
        longArcLineBGLayer.add(anim, forKey: nil)
    }
}
