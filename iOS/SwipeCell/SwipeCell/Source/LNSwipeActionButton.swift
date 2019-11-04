//
//  LNSwipeActionButton.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/26.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class LNSwipeActionButton: UIButton {
    var spacing: CGFloat = 8
    var shouldHighlight = true
    var highlightedBackgroundColor: UIColor?
    
    var maximumImageHeihgt: CGFloat = 0
    
    var verticalAlignment: LNSwipeVerticalAlignment = .centerFirstBaseline
    
    var currentSpacing: CGFloat {
        if currentTitle?.isEmpty == false &&
            imageHeight > 0 {
            return spacing
        } else {
            return 0
        }
    }
    
    var alignmentRect: CGRect {
        let contentRect = self.contentRect(forBounds: bounds)
        let titleHeight = titleBoundingRect(with: verticalAlignment == .centerFirstBaseline ? CGRect.infinite.size : contentRect.size).integral.height
        let totalHeight = imageHeight + titleHeight + currentSpacing
        return contentRect.center(size: CGSize(width: contentRect.width, height: totalHeight))
    }
    
    private var imageHeight: CGFloat {
        if currentImage == nil {
            return 0
        } else {
            return maximumImageHeihgt
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard shouldHighlight else {
                return
            }
            backgroundColor = isHighlighted ? highlightedBackgroundColor : .clear
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: contentEdgeInsets.top + alignmentRect.height + contentEdgeInsets.bottom)
    }
    
    convenience init(action: LNSwipeAction) {
        self.init(frame: .zero)
        
        contentHorizontalAlignment = .center
        
        tintColor = action.textColor ?? .white
        let highlightedTextColor = action.highlightedTextColor ?? tintColor
        highlightedBackgroundColor = action.highlightedBackgroundColor ?? UIColor.black.withAlphaComponent(0.1)
        
        titleLabel?.font = action.font ?? UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel?.textAlignment = .center
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
        
        accessibilityLabel = action.accessibilityLabel
        
        setTitle(action.title, for: .normal)
        setTitleColor(tintColor, for: .normal)
        setTitleColor(highlightedTextColor, for: .highlighted)
        setImage(action.image, for: .normal)
        setImage(action.highlightedImage, for: .highlighted)
    }
    
    func preferredWidth(maximum: CGFloat) -> CGFloat {
        let width = maximum > 0 ? maximum : CGFloat.greatestFiniteMagnitude
        let textWidth = titleBoundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).width
        let imageWidth = currentImage?.size.width ?? 0
        return min(width, max(textWidth, imageWidth) + contentEdgeInsets.left + contentEdgeInsets.right)
    }
    
    func titleBoundingRect(with size: CGSize) -> CGRect {
        guard let title = currentTitle,
            let font = titleLabel?.font
            else {
                return .zero
        }
        let rect = title.boundingRect(with: size,
                                      options: [.usesLineFragmentOrigin],
                                      attributes: [NSAttributedString.Key.font: font],
                                      context: nil)
        return rect
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = contentRect.center(size: titleBoundingRect(with: contentRect.size).size)
        rect.origin.y = alignmentRect.minY + imageHeight + currentSpacing
        return rect
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = contentRect.center(size: currentImage?.size ?? .zero)
        rect.origin.y = alignmentRect.minY + (imageHeight - rect.height) * 0.5
        return rect
    }
}

extension CGRect {
    func center(size: CGSize) -> CGRect {
        let dx = width - size.width
        let dy = height - size.height
        return CGRect(origin: CGPoint(x: origin.x + dx * 0.5, y: origin.y + dy * 0.5), size: size)
    }
}
