//
//  LNAnimationView.swift
//  AnimationButton
//
//  Created by Ning Li on 2018/12/25.
//  Copyright © 2018 Ning Li. All rights reserved.
//

import UIKit

protocol LNAnimationViewDelegate: class {
    /// 动画开始回调
    func animationDidStart(_ animationView: LNAnimationView)
    /// 动画结束回调
    func animationDidStop(_ animationView: LNAnimationView)
}

extension LNAnimationViewDelegate {
    func animationDidStart(_ animationView: LNAnimationView) { }
    func animationDidStop(_ animationView: LNAnimationView) { }
}

class LNAnimationView: UIView {
    
    weak var delegate: LNAnimationViewDelegate?
    
    var status: LNAnimationStatus = .normal {
        didSet {
            switch status {
            case .normal:
                roundLayer.isHidden = true
                successLayer.isHidden = true
            case .loading:
                showLoadingAnimation()
            case .success:
                showSuccessAnimation()
            default:
                break
            }
        }
    }

    private lazy var roundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2
        return layer
    }()
    
    private lazy var successLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2
        layer.lineJoin = .round
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingUI() {
        roundLayer.isHidden = true
        successLayer.isHidden = true
        layer.addSublayer(roundLayer)
        layer.addSublayer(successLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let roundPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height * 0.5)
        roundLayer.path = roundPath.cgPath
        roundLayer.frame = bounds
        
        let successPath = UIBezierPath()
        let firstPoint = CGPoint(x: 2, y: bounds.height * 0.5)
        let circleCenter = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let secondPoint = calculateCircleCoordinate(circleCenter, angle: 220, radius: bounds.height * 0.5)
        let thirdPoint = calculateCircleCoordinate(circleCenter, angle: 20, radius: bounds.height * 0.5)
        successPath.move(to: firstPoint)
        successPath.addLine(to: CGPoint(x: secondPoint.x + 5, y: secondPoint.y))
        successPath.addLine(to: CGPoint(x: thirdPoint.x - 2, y: thirdPoint.y))
        successLayer.path = successPath.cgPath
        successLayer.frame = bounds
        successLayer.strokeEnd = 0
    }
    
    private func calculateCircleCoordinate(_ center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
        let x = radius * cos(angle * CGFloat.pi / 180)
        let y = radius * sin(angle * CGFloat.pi / 180)
        return CGPoint(x: center.x + x, y: center.y - y)
    }
}

// MARK: - Animation
private extension LNAnimationView {
    /// 显示 loading 动画
    func showLoadingAnimation() {
        setNeedsLayout()
        roundLayer.removeAllAnimations()
        roundLayer.isHidden = false
        successLayer.isHidden = true
        let animDuration: CFTimeInterval = 0.8
        let startAnim = CABasicAnimation(keyPath: "strokeEnd")
        startAnim.fromValue = 0
        startAnim.toValue = 0.95
        startAnim.beginTime = 0
        startAnim.duration = animDuration
        startAnim.isRemovedOnCompletion = false
        startAnim.fillMode = .forwards
        startAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.62, 0, 0.38, 1.0)
        
        let endAnim = CABasicAnimation(keyPath: "strokeStart")
        endAnim.fromValue = 0
        endAnim.toValue = 0.95
        endAnim.beginTime = animDuration
        endAnim.duration = animDuration
        endAnim.isRemovedOnCompletion = false
        endAnim.fillMode = .forwards
        endAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.62, 0, 0.38, 1.0)
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        let startAngle = Float.pi * 0.5
        rotationAnim.fromValue = startAngle
        rotationAnim.toValue = startAngle + Float.pi * 2
        rotationAnim.duration = 1.5
        rotationAnim.isRemovedOnCompletion = false
        rotationAnim.fillMode = .forwards
        rotationAnim.timingFunction = CAMediaTimingFunction(name: .linear)
        
        let group = CAAnimationGroup()
        group.duration = 2 * animDuration
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        group.repeatCount = MAXFLOAT
        group.animations = [startAnim, endAnim, rotationAnim]
        group.delegate = self
        group.setValue("LoadingAnimation", forKey: "LoadingAnimation")
        DispatchQueue.main.async {
            self.roundLayer.add(group, forKey: nil)
        }
    }
    
    /// 成功动画
    func showSuccessAnimation() {
        setNeedsLayout()
        successLayer.isHidden = false
        roundLayer.removeAllAnimations()
        successLayer.removeAllAnimations()
        DispatchQueue.main.async {
            let roundAnim = CABasicAnimation(keyPath: "strokeEnd")
            roundAnim.fromValue = 0
            roundAnim.toValue = 1
            roundAnim.beginTime = 0
            roundAnim.duration = 0.5
            roundAnim.isRemovedOnCompletion = false
            roundAnim.fillMode = .forwards
            self.roundLayer.add(roundAnim, forKey: nil)
            
            let successAnim = CABasicAnimation(keyPath: "strokeEnd")
            successAnim.fromValue = 0
            successAnim.toValue = 1
            successAnim.beginTime = CACurrentMediaTime() + 0.5
            successAnim.duration = 0.3
            successAnim.isRemovedOnCompletion = false
            successAnim.fillMode = .forwards
            successAnim.delegate = self
            successAnim.setValue("SuccessAnimation", forKey: "SuccessAnimation")
            self.successLayer.add(successAnim, forKey: nil)
        }
    }
}

// MARK: - CAAnimationDelegate
extension LNAnimationView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        if anim.value(forKey: "LoadingAnimation") != nil {
            delegate?.animationDidStart(self)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim.value(forKey: "SuccessAnimation") != nil {
            delegate?.animationDidStop(self)
        }
    }
}
