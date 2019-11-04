//
//  LNCircleLayerConfiguration.swift
//  CircleView
//
//  Created by Ning Li on 2019/9/10.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

/// 圆环配置信息
struct LNCircleLayerConfiguration {
    /// 圆环宽度
    var lineWidth: CGFloat = 5
    /// 圆环颜色
    var lineColor: UIColor = UIColor.white
    /// 是否是顺时针 - Default: true
    var isClockwise: Bool = true
    /// 起始位置
    var startPoint: CGPoint = CGPoint.zero
    /// 结束位置
    var endPoint: CGPoint = CGPoint.zero
    /// 渐变色数组
    var colors = [CGColor]()
    /// 每个颜色起始位置数组
    var colorSize = [CGFloat]()
    
    init(lineWidth: CGFloat, lineColor: UIColor, isClockwise: Bool = true, startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], colorSize: [CGFloat]) {
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.isClockwise = isClockwise
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.colors = colors.map { $0.cgColor }
        self.colorSize = colorSize
    }
    
    init() { }
}
