//
//  LNSwipeTranstionLayout.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNSwipeTranstionLayout {
    func container(view: UIView, didChangeVisibleWidthWithContext context: ActionsViewLayoutContext)
    func layout(view: UIView, at index: Int, with context: ActionsViewLayoutContext)
    func visibleWidthsForViews(with context: ActionsViewLayoutContext) -> [CGFloat]
}

struct ActionsViewLayoutContext {
    let numberOfActions: Int
    let contentSize: CGSize
    let visiableWidth: CGFloat
    let minimumButtonWidth: CGFloat
    
    init(numberOfActions: Int, contentSize: CGSize = .zero, visiableWidth: CGFloat = 0, minimumButtonWidth: CGFloat = 0) {
        self.numberOfActions = numberOfActions
        self.contentSize = contentSize
        self.visiableWidth = visiableWidth
        self.minimumButtonWidth = minimumButtonWidth
    }
    
    static func newContext(for actionsView: LNSwipeActionsView) -> ActionsViewLayoutContext {
        return ActionsViewLayoutContext(numberOfActions: actionsView.actions.count,
                                        contentSize: actionsView.contentSize,
                                        visiableWidth: actionsView.visibleWidth,
                                        minimumButtonWidth: actionsView.minimumButtonWidth)
    }
}

class BorderTransitionLayout: LNSwipeTranstionLayout {
    func container(view: UIView, didChangeVisibleWidthWithContext context: ActionsViewLayoutContext) {
        
    }
    
    func layout(view: UIView, at index: Int, with context: ActionsViewLayoutContext) {
        let diff = context.visiableWidth - context.contentSize.width
        view.frame.origin.x = CGFloat(index) * context.contentSize.width / CGFloat(context.numberOfActions) + diff
    }
    
    func visibleWidthsForViews(with context: ActionsViewLayoutContext) -> [CGFloat] {
        let diff = context.visiableWidth - context.contentSize.width
        let visibleWidth = context.contentSize.width / CGFloat(context.numberOfActions) + diff
        return (0..<context.numberOfActions).map { _ in visibleWidth }
    }
}

class DragTransitionLayout: LNSwipeTranstionLayout {
    func container(view: UIView, didChangeVisibleWidthWithContext context: ActionsViewLayoutContext) {
        view.bounds.origin.x = context.contentSize.width - context.visiableWidth
    }
    
    func layout(view: UIView, at index: Int, with context: ActionsViewLayoutContext) {
        view.frame.origin.x = CGFloat(index) * context.minimumButtonWidth
    }
    
    func visibleWidthsForViews(with context: ActionsViewLayoutContext) -> [CGFloat] {
        let widths = (0..<context.numberOfActions).map { max(0, min(CGFloat(context.minimumButtonWidth), context.visiableWidth - CGFloat($0) * context.minimumButtonWidth)) }
        return widths
    }
}

class RevealTransitionLayout: DragTransitionLayout {
    override func container(view: UIView, didChangeVisibleWidthWithContext context: ActionsViewLayoutContext) {
        let width = context.minimumButtonWidth * CGFloat(context.numberOfActions)
        view.frame.origin.x = width - context.visiableWidth
    }
    
    override func visibleWidthsForViews(with context: ActionsViewLayoutContext) -> [CGFloat] {
        return super.visibleWidthsForViews(with: context).reversed()
    }
}
