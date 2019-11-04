//
//  LNSwipeActionsView.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNSwipeActionsViewDelegate: class {
    func swipeActionsView(_ swipeActionsView: LNSwipeActionsView, didSelect action: LNSwipeAction)
}

class LNSwipeActionsView: UIView {
    weak var delegate: LNSwipeActionsViewDelegate?
    
    let transitionLayout: LNSwipeTranstionLayout
    var layoutContext: ActionsViewLayoutContext
    
    var feedbackGenerator: LNSwipeFeedback
    
    var expansionAnimator: LNSwipeAnimator?
    
    var expansionDelegate: LNSwipeExpanding? {
        return options.exoansionDelegate ?? (expandableAction?.hasBackgroundColor == false ? LNScaleAndAlphaExpansion.default : nil)
    }
    
    var safeAreaInsetView: UIView?
    let options: LNSwipeOptions
    let actions: [LNSwipeAction]
    
    var buttons: [LNSwipeActionButton] = []
    
    var minimumButtonWidth: CGFloat = 0
    var maximumImageHeight: CGFloat  {
        return actions.reduce(0, { initial, next in max(initial, next.image?.size.height ?? 0) })
    }
    
    var safeAreaMargin: CGFloat {
        guard #available(iOS 11, *),
            let scrollView = safeAreaInsetView
            else {
                return 0
        }
        return scrollView.safeAreaInsets.right
    }
    
    var visibleWidth: CGFloat = 0 {
        didSet {
            visibleWidth = max(0, visibleWidth - safeAreaMargin)
            
            let preLayoutVisibleWidths = transitionLayout.visibleWidthsForViews(with: layoutContext)
            
            layoutContext = ActionsViewLayoutContext.newContext(for: self)
            
            transitionLayout.container(view: self, didChangeVisibleWidthWithContext: layoutContext)
            
            setNeedsLayout()
            layoutIfNeeded()
            
            notifyVisibleWidthChanged(oldWidths: preLayoutVisibleWidths,
                                      newWidths: transitionLayout.visibleWidthsForViews(with: layoutContext))
        }
    }
    
    var preferredWidth: CGFloat {
        return minimumButtonWidth * CGFloat(actions.count) + safeAreaMargin
    }
    
    var contentSize: CGSize {
        if options.expansionsStyle?.elasticOverscroll != true || visibleWidth < preferredWidth {
            return CGSize(width: visibleWidth, height: bounds.height)
        } else {
            let scrollRatio = max(0, visibleWidth - preferredWidth)
            return CGSize(width: preferredWidth + scrollRatio * 0.25, height: bounds.height)
        }
    }
    
    private(set) var expanded: Bool = false
    
    var expandableAction: LNSwipeAction? {
        if options.expansionsStyle != nil {
            return actions.last
        } else {
            return nil
        }
    }

    init(contentEdgesInsets: UIEdgeInsets, maxSize: CGSize, safeAreaInsetView: UIView, options: LNSwipeOptions, actions: [LNSwipeAction]) {
        self.safeAreaInsetView = safeAreaInsetView
        self.options = options
        self.actions = actions
        
        switch options.transitionStyle {
        case .border:
            transitionLayout = BorderTransitionLayout()
        case .reveal:
            transitionLayout = RevealTransitionLayout()
        default:
            transitionLayout = DragTransitionLayout()
        }
        
        layoutContext = ActionsViewLayoutContext(numberOfActions: actions.count)
        
        feedbackGenerator = LNSwipeFeedback(style: .light)
        feedbackGenerator.prepare()
        
        super.init(frame: .zero)
        
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        #if canImport(Combine)
        if let backgroundColor = options.backgroundColor {
            self.backgroundColor = backgroundColor
        } else if #available(iOS 13, *) {
            backgroundColor = UIColor.systemGray5
        } else {
            backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        #else
        if let background = options.backgroundColor {
            self.backgroundColor = backgroundColor
        } else {
            backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        #endif
        buttons = addButtons(for: actions, withMaximum: maxSize, contentEdgeInsets: contentEdgesInsets)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtons(for actions: [LNSwipeAction], withMaximum size: CGSize, contentEdgeInsets: UIEdgeInsets) -> [LNSwipeActionButton] {
        let buttons: [LNSwipeActionButton] = actions.map { (action) in
            let actionButton = LNSwipeActionButton(action: action)
            actionButton.addTarget(self, action: #selector(actionTapped(_:)), for: .touchUpInside)
            actionButton.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            actionButton.spacing = options.buttonSpacing ?? 8
            actionButton.contentEdgeInsets = buttonEdgeInsets(from: options)
            return actionButton
        }
        
        let maximum = options.maximumButtonWidth ?? (size.width - 30) / CGFloat(actions.count)
        let minimum = options.minimumButtonWidth ?? min(maximum, 74)
        minimumButtonWidth = buttons.reduce(minimum, { initial, next in max(initial, next.preferredWidth(maximum: maximum)) })
        
        buttons.enumerated().forEach { (index, button) in
            let action = actions[index]
            let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: bounds.height))
            let wrapperView = LNSwipeActionButtonWrapperView(frame: frame, action: action, contentWidth: minimumButtonWidth)
            wrapperView.translatesAutoresizingMaskIntoConstraints = false
            wrapperView.addSubview(button)
            
            if let effect = action.backgroundEffect {
                let effectView = UIVisualEffectView(effect: effect)
                effectView.frame = wrapperView.frame
                effectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                effectView.contentView.addSubview(wrapperView)
                addSubview(effectView)
            } else {
                addSubview(wrapperView)
            }
            
            button.frame = wrapperView.contentRect
            button.maximumImageHeihgt = maximumImageHeight
            button.verticalAlignment = options.buttonVerticalAlignment
            button.shouldHighlight = action.hasBackgroundColor
            
            wrapperView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            wrapperView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            
            let topConstraint = wrapperView.topAnchor.constraint(equalTo: topAnchor, constant: contentEdgeInsets.top)
            topConstraint.priority = contentEdgeInsets.top == 0 ? .required : .defaultHigh
            topConstraint.isActive = true
            
            let bottomConstraint = wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * contentEdgeInsets.bottom)
            bottomConstraint.priority = contentEdgeInsets.bottom == 0 ? .required : .defaultHigh
            bottomConstraint.isActive = true
            
            if contentEdgeInsets != .zero {
                let heightConstraint = wrapperView.heightAnchor.constraint(greaterThanOrEqualToConstant: button.intrinsicContentSize.height)
                heightConstraint.priority = .required
                heightConstraint.isActive = true
            }
        }
        return buttons
    }
    
    func buttonEdgeInsets(from options: LNSwipeOptions) -> UIEdgeInsets {
        let padding = options.buttonPadding ?? 8
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
    
    func setExpanded(expanded: Bool, feedback: Bool = false) {
        guard self.expanded != expanded else {
            return
        }
        self.expanded = expanded
        
        if feedback {
            feedbackGenerator.impactOccurred()
            feedbackGenerator.prepare()
        }
        
        let timingParameters = expansionDelegate?.animationTimingParameters(buttons: buttons.reversed(), expanding: expanded)
        
        if expansionAnimator?.isRunning == true {
            expansionAnimator?.stopAnimation(true)
        }
        
        if #available(iOS 10, *) {
            expansionAnimator = UIViewPropertyAnimator(duration: timingParameters?.duration ?? 0.6, dampingRatio: 1.0)
        } else {
            expansionAnimator = UIViewSpringAnimator(duration: timingParameters?.duration ?? 0.6,
                                                     damping: 1.0,
                                                     initialVelocity: 1.0)
        }
        expansionAnimator?.addAnimations {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        
        expansionAnimator?.startAnimation(afterDelay: timingParameters?.delay ?? 0)
        
        notifyExpansion(expanded: expanded)
    }
    
    func notifyVisibleWidthChanged(oldWidths: [CGFloat], newWidths: [CGFloat]) {
        DispatchQueue.main.async {
            oldWidths.enumerated().forEach { (index, oldWidth) in
                let newWidth = newWidths[index]
                if oldWidth != newWidth {
                    let context = LNSwipeActionTransitioningContext(actionIdentifier: self.actions[index].identifier,
                                                                    button: self.buttons[index],
                                                                    newPercentVisible: newWidth / self.minimumButtonWidth,
                                                                    oldPercentVisible: oldWidth / self.minimumButtonWidth,
                                                                    wrapperView: self.subviews[index])
                    self.actions[index].transitionDelegate?.didTransition(with: context)
                }
            }
        }
    }
    
    func notifyExpansion(expanded: Bool) {
        guard let expandedButton = buttons.last else {
            return
        }
        expansionDelegate?.actionButton(expandedButton, didChange: expanded, otherActionButtons: buttons.dropLast().reversed())
    }
    
    func createDeletionMask() -> UIView {
        let mask = UIView(frame: CGRect(x: min(0, frame.minX),
                                        y: 0,
                                        width: bounds.width * 2,
                                        height: bounds.height))
        mask.backgroundColor = UIColor.white
        return mask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for subview in subviews.enumerated() {
            transitionLayout.layout(view: subview.element, at: subview.offset, with: layoutContext)
        }
        
        if expanded {
            subviews.last?.frame.origin.x = bounds.origin.x
        }
    }
}

extension LNSwipeActionsView {
    @objc private func actionTapped(_ button: LNSwipeActionButton) {
        guard let index = buttons.firstIndex(of: button) else {
            return
        }
        delegate?.swipeActionsView(self, didSelect: actions[index])
    }
}


class LNSwipeActionButtonWrapperView: UIView {
    let contentRect: CGRect
    var actionBackgroundColor: UIColor?
    
    init(frame: CGRect, action: LNSwipeAction, contentWidth: CGFloat) {
        contentRect = CGRect(x: 0, y: 0, width: contentWidth, height: frame.height)
        super.init(frame: frame)
        
        configureBackgroundColor(with: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if let actionBackgroundColor = self.actionBackgroundColor,
            let context = UIGraphicsGetCurrentContext() {
            actionBackgroundColor.setFill()
            context.fill(rect)
        }
    }
    
    func configureBackgroundColor(with action: LNSwipeAction) {
        guard action.hasBackgroundColor else {
            isOpaque = false
            return
        }
        
        if let backgroundColor = action.backgroundColor {
            actionBackgroundColor = backgroundColor
        } else {
            switch action.style {
            case .destructive:
                #if canImport(Combine)
                if #available(iOS 13, *) {
                    actionBackgroundColor = UIColor.systemRed
                } else {
                    actionBackgroundColor = #colorLiteral(red: 1, green: 0.2352941185, blue: 0.1782931915, alpha: 1)
                }
                #else
                actionBackgroundColor = #colorLiteral(red: 1, green: 0.2352941185, blue: 0.1782931915, alpha: 1)
                #endif
            default:
                #if canImport(Combine)
                if #available(iOS 13, *) {
                    actionBackgroundColor = UIColor.systemGray3
                } else {
                    actionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
                #else
                actionBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                #endif
            }
        }
    }
}
