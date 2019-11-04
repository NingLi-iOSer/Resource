//
//  LNSteppedProgressBar.swift
//  SteppedProgressBar
//
//  Created by Ning Li on 2019/10/28.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

/// 文本位置
public enum LNSteppedProgressBarTextLocation {
    case top, bottom, center
}

public protocol LNSteppedProgressBarDelegate: class {
    /// 将要选中
    /// - Parameter progress: 进度条
    /// - Parameter index: 进度索引
    func progressBar(_ progressBar: LNSteppedProgressBar, willSelecteItemAt index: Int)
    
    /// 已选中
    /// - Parameter progressBar: 进度条
    /// - Parameter index: 进度索引
    func progressBar(_ progressBar: LNSteppedProgressBar, didSelectedItemAt index: Int)
    
    /// 能否选中
    /// - Parameter progressBar: 进度条
    /// - Parameter index: 进度索引
    func progressBar(_ progressBar: LNSteppedProgressBar, canSelectItemAt index: Int) -> Bool
    
    /// 进度文本
    /// - Parameter progressBar: 进度条
    /// - Parameter index: 进度索引
    /// - Parameter position: position
    func progressBar(_ progressBar: LNSteppedProgressBar, textAt index: Int, position: LNSteppedProgressBarTextLocation) -> String
}

public extension LNSteppedProgressBarDelegate {
    func progressBar(_ progressBar: LNSteppedProgressBar, willSelecteItemAt index: Int) { }
    func progressBar(_ progressBar: LNSteppedProgressBar, didSelectedItemAt index: Int) { }
    func progressBar(_ progressBar: LNSteppedProgressBar, canSelectItemAt index: Int) -> Bool { return true }
    func progressBar(_ progressBar: LNSteppedProgressBar, textAt index: Int, position: LNSteppedProgressBarTextLocation) -> String { return "" }
}

/// 进度指示器
@IBDesignable public class LNSteppedProgressBar: UIView {
    
    /// 进度点数
    @IBInspectable public var numberOfPoint: Int = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 当前进度
    public var currentIndex: Int = 0 {
        willSet {
            delegate?.progressBar(self, willSelecteItemAt: newValue)
        }
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 完成到指定进度
    public var completedTillIndex: Int = -1 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var currentSelectedCenterColor: UIColor = UIColor.black
    public var currentSelectedTextColor: UIColor!
    public var viewBackgroundColor: UIColor = UIColor.white
    public var selectedOuterCircleStrokeColor: UIColor!
    public var lastStateOuterCircleStrokeColor: UIColor!
    public var lastStateCenterColor: UIColor!
    public var centerLayerTextColor: UIColor!
    public var centerLayerDarkBackgroundTextColor: UIColor = UIColor.white
    
    public var useLastState: Bool = false {
        didSet {
            if useLastState {
                layer.addSublayer(clearLastStateLayer)
                layer.addSublayer(lastStateLayer)
                layer.addSublayer(lastStateCenterLayer)
            }
            setNeedsDisplay()
        }
    }
    
    /// 点之间线高
    @IBInspectable public var lineHeight: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var _lineHeight: CGFloat {
        if lineHeight == 0 || lineHeight > bounds.height {
            return bounds.height * 0.4
        }
        return lineHeight
    }
    
    /// 选中的点线宽
    public var selecteOuterCircleLineWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var lastStateOuterCircleLineWidth: CGFloat = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var textDistance: CGFloat = 20 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 点半径
    @IBInspectable public var radius: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var _radius: CGFloat {
        if radius == 0 || radius > bounds.height * 0.5 {
            return bounds.height * 0.5
        }
        return radius
    }
    
    /// 进度点半径
    @IBInspectable public var progressRadius: CGFloat = 0 {
        didSet {
            maskLayer.cornerRadius = progressRadius
            setNeedsDisplay()
        }
    }
    
    private var _progressRadius: CGFloat {
        if progressRadius == 0 || progressRadius > bounds.height * 0.5 {
            return bounds.height * 0.5
        }
        return progressRadius
    }
    
    /// 进度线高
    @IBInspectable public var progressLineHeight: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var _progressLineHeight: CGFloat {
        if progressLineHeight == 0 || progressLineHeight > _lineHeight {
            return _lineHeight
        }
        return progressLineHeight
    }
    
    /// 选中动画时长
    @IBInspectable public var stepAnimationDuration: CFTimeInterval = 0.3
    
    /// 显示进度文本
    @IBInspectable public var displayStepText: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 进度文本字体
    public var stepTextFont: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 进度文本颜色
    public var stepTextColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 背景色
    @IBInspectable public var backgroundShapeColor: UIColor = UIColor(red: 238.0 / 255.0, green: 238.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 选中时背景色
    @IBInspectable public var selectedBackgroundColor: UIColor = UIColor(red: 251.0 / 255.0, green: 251.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public weak var delegate: LNSteppedProgressBarDelegate?
    
    // MARK: - Private Properties
    private lazy var backgroundLayer = CAShapeLayer()
    private lazy var progressLayer = CAShapeLayer()
    private lazy var selectionLayer = CAShapeLayer()
    private lazy var clearSelectionLayer = CAShapeLayer()
    private lazy var clearLastStateLayer = CAShapeLayer()
    private lazy var lastStateLayer = CAShapeLayer()
    private lazy var lastStateCenterLayer = CAShapeLayer()
    private lazy var selectionCenterLayer = CAShapeLayer()
    private lazy var roadToSelectionLayer = CAShapeLayer()
    private lazy var clearCentersLayer = CAShapeLayer()
    private lazy var maskLayer = CAShapeLayer()
    private lazy var centerPoints = [CGPoint]()
    private lazy var _textLayers = [Int: CATextLayer]()
    private lazy var _topTextLayers = [Int: CATextLayer]()
    private lazy var _bottomTextLayers = [Int: CATextLayer]()
    private var previousIndex: Int = 0
    /// 动画渲染
    private var animationRendering = false
    
    // MARK: - Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

// MARK: - Settings
extension LNSteppedProgressBar {
    private func commonInit() {
        if currentSelectedTextColor == nil {
            currentSelectedTextColor = selectedBackgroundColor
        }
        
        if lastStateCenterColor == nil {
            lastStateCenterColor = backgroundShapeColor
        }
        
        if stepTextColor == nil {
            stepTextColor = UIColor.black
        }
        
        if selectedOuterCircleStrokeColor == nil {
            selectedOuterCircleStrokeColor = selectedBackgroundColor
        }
        
        if lastStateOuterCircleStrokeColor == nil {
            lastStateOuterCircleStrokeColor = selectedBackgroundColor
        }
        
        if stepTextFont == nil {
            stepTextFont = UIFont.systemFont(ofSize: 14)
        }
        
        if centerLayerTextColor == nil {
            centerLayerTextColor = stepTextColor
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(gestureAction(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(gestureAction(_:)))
        addGestureRecognizer(tap)
        addGestureRecognizer(pan)
        
        layer.addSublayer(clearCentersLayer)
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(clearSelectionLayer)
        layer.addSublayer(selectionCenterLayer)
        layer.addSublayer(selectionLayer)
        layer.addSublayer(roadToSelectionLayer)
        
        progressLayer.mask = maskLayer
        
        contentMode = .redraw
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if !useLastState {
            completedTillIndex = currentIndex
        }
        
        centerPoints.removeAll()
        
        let largerRadius = fmax(_radius, _progressRadius)
        let distanceBetweenCircles = (bounds.width - CGFloat(numberOfPoint) * 2 * largerRadius) / CGFloat(numberOfPoint - 1)
        var xCursor: CGFloat = largerRadius
        
        for _ in 0..<numberOfPoint {
            centerPoints.append(CGPoint(x: xCursor, y: bounds.height * 0.5))
            xCursor += 2 * largerRadius + distanceBetweenCircles
        }
        
        let largerLineWidth = fmax(selecteOuterCircleLineWidth, lastStateOuterCircleLineWidth)
        
        if !animationRendering {
            let clearCentersPath = _shapePath(centerPoints, aRadius: largerRadius + largerLineWidth, aLineHeight: _lineHeight)
            clearCentersLayer.path = clearCentersPath.cgPath
            clearCentersLayer.fillColor = viewBackgroundColor.cgColor
            
            let bgPath = _shapePath(centerPoints, aRadius: _radius, aLineHeight: _lineHeight)
            backgroundLayer.path = bgPath.cgPath
            backgroundLayer.fillColor = backgroundShapeColor.cgColor
            
            let progressPath = _shapePath(centerPoints, aRadius: _progressRadius, aLineHeight: _progressLineHeight)
            progressLayer.path = progressPath.cgPath
            progressLayer.fillColor = selectedBackgroundColor.cgColor
            
            let clearSelectedRadius = fmax(_progressRadius, _progressRadius + selecteOuterCircleLineWidth)
            let clearSelectedPath = _shapePathForSelected(centerPoints[currentIndex], aRadius: clearSelectedRadius)
            clearSelectionLayer.path = clearSelectedPath.cgPath
            clearSelectionLayer.fillColor = viewBackgroundColor.cgColor
            
            let selectedPath = _shapePathForSelected(centerPoints[currentIndex], aRadius: _radius)
            selectionLayer.path = selectedPath.cgPath
            selectionLayer.fillColor = currentSelectedCenterColor.cgColor
            
            if !useLastState {
                let selectedPathCenter = _shapePathForSelectedPathCenter(centerPoints[currentIndex], aRadius: _progressRadius)
                selectionCenterLayer.path = selectedPathCenter.cgPath
                selectionCenterLayer.strokeColor = selectedOuterCircleStrokeColor.cgColor
                selectionCenterLayer.fillColor = UIColor.clear.cgColor
                selectionCenterLayer.lineWidth = selecteOuterCircleLineWidth
                selectionCenterLayer.strokeEnd = 1.0
            } else {
                let selectedPathCenter = _shapePathForSelectedPathCenter(centerPoints[currentIndex], aRadius: _progressRadius + selecteOuterCircleLineWidth)
                selectionCenterLayer.path = selectedPathCenter.cgPath
                selectionCenterLayer.strokeColor = selectedOuterCircleStrokeColor.cgColor
                selectionCenterLayer.fillColor = UIColor.clear.cgColor
                selectionCenterLayer.lineWidth = selecteOuterCircleLineWidth
                
                if completedTillIndex >= 0 {
                    let lastStateLayerPath = _shapePathForLastState(centerPoints[completedTillIndex])
                    lastStateLayer.path = lastStateLayerPath.cgPath
                    lastStateLayer.strokeColor = lastStateOuterCircleStrokeColor.cgColor
                    lastStateLayer.fillColor = viewBackgroundColor.cgColor
                    lastStateLayer.lineWidth = lastStateOuterCircleLineWidth
                    
                    let lastStateCenterLayerPath = _shapePathForSelected(centerPoints[completedTillIndex], aRadius: _radius)
                    lastStateCenterLayer.path = lastStateCenterLayerPath.cgPath
                    lastStateCenterLayer.fillColor = lastStateCenterColor.cgColor
                }
                
                if currentIndex > 0 {
                    let lastPoint = centerPoints[currentIndex - 1]
                    let centerCurrent = centerPoints[currentIndex]
                    let xCursor = centerCurrent.x - progressRadius - _radius
                    let routeToSelectedPath = UIBezierPath()
                    
                    routeToSelectedPath.move(to: CGPoint(x: lastPoint.x + progressRadius + selecteOuterCircleLineWidth,
                                                         y: lastPoint.y))
                    routeToSelectedPath.addLine(to: CGPoint(x: xCursor, y: centerCurrent.y))
                    roadToSelectionLayer.path = routeToSelectedPath.cgPath
                    roadToSelectionLayer.strokeColor = selectedBackgroundColor.cgColor
                    roadToSelectionLayer.lineWidth = progressLineHeight
                }
            }
        }
        
        renderTopTextIndexes()
        renderBottomTextIndexes()
        renderTextIndexes()
        
        let progressCenterPoints = Array(centerPoints[0..<(completedTillIndex + 1)])
        
        if let currentProgressCenterPoint = progressCenterPoints.last {
            let maskPath = _maskPath(currentProgressCenterPoint)
            maskLayer.path = maskPath.cgPath
            
            CATransaction.begin()
            let progressAnimation = CABasicAnimation(keyPath: "path")
            progressAnimation.duration = stepAnimationDuration * CFTimeInterval(abs(completedTillIndex - previousIndex))
            progressAnimation.toValue = maskPath
            progressAnimation.isRemovedOnCompletion = false
            progressAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            CATransaction.setCompletionBlock {
                if self.animationRendering {
                    self.delegate?.progressBar(self, didSelectedItemAt: self.currentIndex)
                    self.animationRendering = false
                }
            }
            
            maskLayer.add(progressAnimation, forKey: "progressAnimation")
            CATransaction.commit()
        }
        
        previousIndex = currentIndex
    }
    
    private func _shapePath(_ centerPoints: [CGPoint], aRadius: CGFloat, aLineHeight: CGFloat) -> UIBezierPath {
        let nbPoint = centerPoints.count
        
        let path = UIBezierPath()
        
        var distanceBetweenCircles: CGFloat = 0
        
        if let first = centerPoints.first,
            nbPoint > 2 {
            let second = centerPoints[1]
            distanceBetweenCircles = second.x - first.x - 2 * aRadius
        }
        
        let angle = aLineHeight * 0.5 / aRadius
        
        var xCursor: CGFloat = 0
        
        for i in 0...(2 * nbPoint - 1) {
            var index = i
            if index >= nbPoint {
                index = (nbPoint - 1) - (i - nbPoint)
            }
            
            let centerPoint = centerPoints[index]
            var startAngle: CGFloat = 0
            var endAngle: CGFloat = 0
            
            if i == 0 {
                xCursor = centerPoint.x
                startAngle = CGFloat.pi
                endAngle = -angle
            } else if i < nbPoint - 1 {
                startAngle = .pi + angle
                endAngle = -angle
            } else if i == nbPoint - 1 {
                startAngle = .pi + angle
                endAngle = 0
            } else if i == nbPoint {
                startAngle = 0
                endAngle = .pi - angle
            } else if i < 2 * nbPoint - 1 {
                startAngle = angle
                endAngle = .pi - angle
            } else {
                startAngle = angle
                endAngle = .pi
            }
            
            path.addArc(withCenter: centerPoint, radius: aRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            if i < nbPoint - 1 {
                xCursor += aRadius + distanceBetweenCircles
                path.addLine(to: CGPoint(x: xCursor, y: centerPoint.y - aLineHeight * 0.5))
                xCursor += aRadius
            } else if i < (2 * nbPoint - 1) && i >= nbPoint {
                xCursor -= aRadius + distanceBetweenCircles
                path.addLine(to: CGPoint(x: xCursor, y: centerPoint.y + aLineHeight * 0.5))
                xCursor -= aRadius
            }
        }
        return path
    }
    
    private func _shapePathForSelected(_ centerPoint: CGPoint, aRadius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: CGRect(x: centerPoint.x - aRadius,
                                                    y: centerPoint.y - aRadius,
                                                    width: 2 * aRadius,
                                                    height: 2 * aRadius),
                                cornerRadius: aRadius)
        return path
    }
    
    private func _shapePathForSelectedPathCenter(_ centerPoint: CGPoint, aRadius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: CGRect(x: centerPoint.x - aRadius,
                                                    y: centerPoint.y - aRadius,
                                                    width: 2 * aRadius,
                                                    height: 2 * aRadius),
                                cornerRadius: aRadius)
        return path
    }
    
    private func _shapePathForLastState(_ center: CGPoint) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: center, radius: _progressRadius + lastStateOuterCircleLineWidth, startAngle: 0, endAngle: 4 * .pi, clockwise: true)
        return path
    }
    
    private func renderTextIndexes() {
        for i in 0..<numberOfPoint {
            let centerPoint = centerPoints[i]
            let textLayer = _textLayer(at: i)
            let textLayerFont = UIFont.boldSystemFont(ofSize: 15)
            textLayer.contentsScale = UIScreen.main.scale
            
            textLayer.font = CTFontCreateWithName(textLayerFont.familyName as CFString, textLayerFont.pointSize, nil)
            textLayer.fontSize = textLayerFont.pointSize
            
            if i == currentIndex || i == completedTillIndex {
                textLayer.foregroundColor = centerLayerDarkBackgroundTextColor.cgColor
            } else {
                textLayer.foregroundColor = centerLayerTextColor.cgColor
            }
            
            if let text = delegate?.progressBar(self, textAt: i, position: .center) {
                textLayer.string = text
            } else {
                textLayer.string = "\(i)"
            }
            
            textLayer.sizeToFit()
            textLayer.frame = CGRect(x: centerPoint.x - textLayer.bounds.width * 0.5,
                                     y: centerPoint.y - textLayer.bounds.height * 0.5,
                                     width: textLayer.bounds.width,
                                     height: textLayer.bounds.height)
        }
    }
    
    private func _textLayer(at index: Int) -> CATextLayer {
        let textLayer: CATextLayer
        if let _textLayer = _textLayers[index] {
            textLayer = _textLayer
        } else {
            textLayer = CATextLayer()
            _textLayers[index] = textLayer
        }
        layer.addSublayer(textLayer)
        return textLayer
    }
    
    private func renderTopTextIndexes() {
        for i in 0..<numberOfPoint {
            let centerPoint = centerPoints[i]
            
            let textLayer = _topTextLayer(at: i)
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = stepTextFont
            textLayer.fontSize = stepTextFont!.pointSize
            
            if i == currentIndex {
                textLayer.foregroundColor = currentSelectedTextColor.cgColor
            } else {
                textLayer.foregroundColor = stepTextColor!.cgColor
            }
            
            if let text = delegate?.progressBar(self, textAt: i, position: .top) {
                textLayer.string = text
            } else {
                textLayer.string = "\(i)"
            }
            
            textLayer.sizeToFit()
            textLayer.frame = CGRect(x: centerPoint.x - textLayer.bounds.width * 0.5,
                                     y: centerPoint.y - textLayer.bounds.height * 0.5 - _progressRadius - textDistance,
                                     width: textLayer.bounds.width,
                                     height: textLayer.bounds.height)
        }
    }
    
    private func _topTextLayer(at index: Int) -> CATextLayer {
        let textLayer: CATextLayer
        if let _textLayer = _topTextLayers[index] {
            textLayer = _textLayer
        } else {
            textLayer = CATextLayer()
            _topTextLayers[index] = textLayer
        }
        layer.addSublayer(textLayer)
        return textLayer
    }
    
    private func renderBottomTextIndexes() {
        for i in 0..<numberOfPoint {
            let centerPoint = centerPoints[i]
            
            let textLayer = _bottomTextLayer(at: i)
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.font = stepTextFont
            textLayer.fontSize = stepTextFont!.pointSize
            
            if i == currentIndex {
                textLayer.foregroundColor = currentSelectedTextColor.cgColor
            } else {
                textLayer.foregroundColor = stepTextColor!.cgColor
            }
            
            if let text = delegate?.progressBar(self, textAt: i, position: .bottom) {
                textLayer.string = text
            } else {
                textLayer.string = "\(i)"
            }
            
            textLayer.sizeToFit()
            textLayer.frame = CGRect(x: centerPoint.x - textLayer.bounds.width * 0.5,
                                     y: centerPoint.y - textLayer.bounds.height * 0.5 + _progressRadius + textDistance,
                                     width: textLayer.bounds.width,
                                     height: textLayer.bounds.height)
        }
    }
    
    private func _bottomTextLayer(at index: Int) -> CATextLayer {
        let textLayer: CATextLayer
        if let _textLayer = _bottomTextLayers[index] {
            textLayer = _textLayer
        } else {
            textLayer = CATextLayer()
            _bottomTextLayers[index] = textLayer
        }
        layer.addSublayer(textLayer)
        return textLayer
    }
    
    private func _maskPath(_ currentProgressCenterPoint: CGPoint) -> UIBezierPath {
        let angle = _progressLineHeight * 0.5 / _progressRadius
        let xOffset = cos(angle) * _progressRadius
        
        let maskPath = UIBezierPath()
        maskPath.move(to: CGPoint.zero)
        maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: 0))
        maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: currentProgressCenterPoint.y - _progressLineHeight))
        maskPath.addArc(withCenter: currentProgressCenterPoint, radius: _progressRadius, startAngle: -angle, endAngle: angle, clockwise: true)
        maskPath.addLine(to: CGPoint(x: currentProgressCenterPoint.x + xOffset, y: bounds.height))
        maskPath.addLine(to: CGPoint(x: 0, y: bounds.height))
        maskPath.close()
        return maskPath
    }
}

extension LNSteppedProgressBar {
    /// UIGesture Recognizer
    @objc private func gestureAction(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .ended, .changed:
            let touchPoint = gesture.location(in: self)
            var smallestDistance = CGFloat.infinity
            var selectedIndex = 0
            
            for (index, point) in centerPoints.enumerated() {
                let distance = touchPoint.distanceTo(point)
                if distance < smallestDistance {
                    smallestDistance = distance
                    selectedIndex = index
                }
            }
            
            if currentIndex != selectedIndex,
                let canSelect = delegate?.progressBar(self, canSelectItemAt: selectedIndex),
                canSelect {
                if selectedIndex > completedTillIndex {
                    completedTillIndex = selectedIndex
                }
                currentIndex = selectedIndex
                animationRendering = true
            }
        default:
            break
        }
    }
}

extension CGPoint {
    public func distanceTo(_ point: CGPoint) -> CGFloat {
        let distance = sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
        return distance
    }
}

extension CATextLayer {
    public func sizeToFit() {
        let fontName = CTFontCopyFamilyName(font as! CTFont) as String
        let font = UIFont(name: fontName, size: fontSize)
        let attributes = [NSAttributedString.Key.font: font!]
        let attrString = NSAttributedString(string: string as! String, attributes: attributes)
        
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var width: CGFloat = 0
        
        let line = CTLineCreateWithAttributedString(attrString)
        width = CGFloat(CTLineGetTypographicBounds(line, &ascent, &descent, nil))
        width = ceil(width)
        
        bounds = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: ceil(ascent + descent)))
    }
}
