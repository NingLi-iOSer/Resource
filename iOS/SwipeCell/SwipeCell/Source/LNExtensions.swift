//
//  LNExtensions.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

extension UIScrollView {
    var swipeables: [LNSwipeable] {
        switch self {
        case let tableView as UITableView:
            return tableView.swipeCells
        default:
            return []
        }
    }
    
    func hideSwipeables() {
        switch self {
        case let tableView as UITableView:
            return tableView.hideSwipeCell()
        default:
            return
        }
    }
}

extension UITableView {
    var swipeCells: [LNSwipeCell] {
        return visibleCells.compactMap { $0 as? LNSwipeCell }
    }
    
    func hideSwipeCell() {
        swipeCells.forEach { $0.hideSwipe(animated: true) }
    }
}

extension UIPanGestureRecognizer {
    func elasticTranslation(in view: UIView?, with limit: CGSize, fromOriginalCenter center: CGPoint, applyingRatio ratio: CGFloat = 0.2) -> CGPoint {
        let translation = self.translation(in: view)
        
        guard let sourceView = self.view else {
            return translation
        }
        
        let updatedCenter = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        let distanceFromCenter = CGSize(width: abs(updatedCenter.x - sourceView.bounds.midX),
                                        height: abs(updatedCenter.y - sourceView.bounds.midY))
        
        let inverseRatio = 1.0 - ratio
        let scale: (x: CGFloat, y: CGFloat) = (updatedCenter.x < sourceView.bounds.midX ? -1 : 1,
                                               updatedCenter.y < sourceView.bounds.midY ? -1 : 1)
        let x = updatedCenter.x - (distanceFromCenter.width > limit.width ? inverseRatio * (distanceFromCenter.width - limit.width) * scale.x : 0)
        let y = updatedCenter.y - (distanceFromCenter.height > limit.height ? inverseRatio * (distanceFromCenter.height - limit.height) * scale.y : 0)
        return CGPoint(x: x, y: y)
    }
}
