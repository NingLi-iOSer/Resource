//
//  LNCircleLayer.swift
//  CircleView
//
//  Created by Ning Li on 2019/9/10.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

/// 背景圆环
class LNCircleLayer: CALayer {
    
    private var configuration = LNCircleLayerConfiguration()
    private var gradientCircleLayer: LNGradientCircleLayer!
    
    init(frame: CGRect, configuration: LNCircleLayerConfiguration) {
        super.init()
        self.frame = frame
        self.configuration = configuration
        drawBackgroundLayer()
        gradientCircleLayer = LNGradientCircleLayer(frame: bounds, configuration: configuration)
        addSublayer(gradientCircleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: Float) {
        gradientCircleLayer.setProgress(progress)
    }
    
    /// 绘制背景圆
    private func drawBackgroundLayer() {
        let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        let radius = (bounds.width - configuration.lineWidth) * 0.5
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi * 0.5, endAngle: CGFloat.pi * 1.5, clockwise: true)
        let bgLayer = CAShapeLayer()
        if bounds.width > bounds.height {
            bgLayer.frame = CGRect(x: (bounds.width - bounds.height) * 0.5,
                                   y: 0,
                                   width: bounds.height,
                                   height: bounds.height)
        } else {
            bgLayer.frame = CGRect(x: 0,
                                   y: (bounds.height - bounds.width) * 0.5,
                                   width: bounds.height,
                                   height: bounds.height)
        }
        bgLayer.fillColor = UIColor.clear.cgColor
        bgLayer.lineWidth = configuration.lineWidth
        bgLayer.strokeColor = configuration.lineColor.cgColor
        bgLayer.strokeStart = 0
        bgLayer.strokeEnd = 1
        bgLayer.path = circlePath.cgPath
        addSublayer(bgLayer)
    }
}

/// 渐变圆环
fileprivate class LNGradientCircleLayer: CALayer {
    
    private var configuration = LNCircleLayerConfiguration()
    /// 进度
    private var progress: Float = 0
    
    init(frame: CGRect, configuration: LNCircleLayerConfiguration) {
        super.init()
        self.frame = frame
        self.configuration = configuration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(_ progress: Float) {
        self.progress = progress
        setNeedsDisplay()
    }
    
    override func draw(in ctx: CGContext) {
        ctx.setLineWidth(configuration.lineWidth)
        ctx.setLineCap(.round)
        ctx.setFillColor(UIColor.black.cgColor)
        // 圆心
        let originX = bounds.width * 0.5
        let originY = bounds.height * 0.5
        let radius = min(originX, originY) - configuration.lineWidth * 0.5
        let minAngle = CGFloat.pi / 90 - CGFloat(progress) * CGFloat.pi / 80
        if configuration.isClockwise {
            ctx.addArc(center: CGPoint(x: originX, y: originY),
                       radius: radius,
                       startAngle: -CGFloat.pi * 0.5,
                       endAngle: -CGFloat.pi * 0.5 + minAngle + CGFloat(progress) * 2 * CGFloat.pi,
                       clockwise: false)
        } else {
            ctx.addArc(center: CGPoint(x: originX, y: originY),
                       radius: radius,
                       startAngle: -CGFloat.pi * 0.5,
                       endAngle: -CGFloat.pi * 0.5 - minAngle + CGFloat(1 - progress) * 2 * CGFloat.pi,
                       clockwise: true)
        }
        
        // 创建 RGB 色彩空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: configuration.colors as CFArray,
                                        locations: configuration.colorSize) else {
                                            return
        }
        // 绘制圆环路径
        ctx.replacePathWithStrokedPath()
        // 裁剪路径
        ctx.clip()
        // 填充颜色
        ctx.drawLinearGradient(gradient, start: configuration.startPoint, end: configuration.endPoint, options: .init(rawValue: 1))
    }
}
