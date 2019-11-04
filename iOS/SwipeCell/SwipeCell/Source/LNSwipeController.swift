//
//  LNSwipeController.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNSwipeControllerDelegate: class {
    func swipeControllerCanBeginEditingSwipeable(_ controller: LNSwipeController) -> Bool
    
    func swipeControllerEditActionsForSwipeable(_ controller: LNSwipeController) -> [LNSwipeAction]?

    func swipeControllerEditActionsOptionsForSwipeable(_ controller: LNSwipeController) -> LNSwipeOptions

    func swipeControllerWillBeginEditingSwipeable(_ controller: LNSwipeController)
    
    func swipeControllerDidEndEditingSwipeable(_ controller: LNSwipeController)
    
    func swipeController(_ controller: LNSwipeController, didDeleteSwipeableAt indexPath: IndexPath)
    
    func swipeController(_ controller: LNSwipeController, visiableRectFor scrollView: UIScrollView) -> CGRect?
}

class LNSwipeController: NSObject {
    
    weak var swipeable: (UIView & LNSwipeable)?
    weak var actionsContainerView: UIView?
    
    weak var delegate: LNSwipeControllerDelegate?
    weak var scrollView: UIScrollView?
    
    var animator: LNSwipeAnimator?
    
    let elasticScrollRatio: CGFloat = 0.4
    
    var originalCenter: CGFloat = 0
    var scrollRatio: CGFloat = 1.0
    var originalLayoutMargins: UIEdgeInsets = .zero
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        gesture.delegate = self
        return gesture
    }()
    
    init(swipeable: UIView & LNSwipeable, actionsContainerView: UIView) {
        self.swipeable = swipeable
        self.actionsContainerView = actionsContainerView
        super.init()
        
        configure()
    }
    
    func configure() {
        swipeable?.addGestureRecognizer(tapGestureRecognizer)
        swipeable?.addGestureRecognizer(panGestureRecognizer)
    }
    
    func reset() {
        swipeable?.state = .center
        swipeable?.actionsView?.removeFromSuperview()
        swipeable?.actionsView = nil
    }
    
    @discardableResult
    func showActionsView() -> Bool {
        guard let actions = delegate?.swipeControllerEditActionsForSwipeable(self),
            actions.count > 0
            else {
                return false
        }
        guard let swipeable = self.swipeable else {
            return false
        }
        
        originalLayoutMargins = swipeable.layoutMargins
        
        configureActionsView(with: actions)
        
        delegate?.swipeControllerWillBeginEditingSwipeable(self)
        
        return true
    }
    
    func configureActionsView(with actions: [LNSwipeAction]) {
        guard var swipeable = self.swipeable,
            let actionsContainerView = self.actionsContainerView,
            let scrollView = self.scrollView
            else {
                return
        }
        
        let options = delegate?.swipeControllerEditActionsOptionsForSwipeable(self) ?? LNSwipeOptions()
        
        swipeable.actionsView?.removeFromSuperview()
        swipeable.actionsView = nil
        
        var contentEdgesInsets = UIEdgeInsets.zero
        if let visiableTableViewRect = delegate?.swipeController(self, visiableRectFor: scrollView) {
            let frame = (swipeable as LNSwipeable).frame
            let visiableSwipeableRect = frame.intersection(visiableTableViewRect)
            if visiableSwipeableRect.isNull == false {
                let top: CGFloat
                if visiableSwipeableRect.minY > frame.minY {
                    top = max(0, visiableSwipeableRect.minY - frame.minY)
                } else {
                    top = 0
                }
                
                let bottom = max(0, frame.height - visiableSwipeableRect.height - top)
                contentEdgesInsets = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
            }
        }
        
        let actionsView = LNSwipeActionsView(contentEdgesInsets: contentEdgesInsets,
                                             maxSize: swipeable.bounds.size,
                                             safeAreaInsetView: scrollView,
                                             options: options,
                                             actions: actions)
        actionsView.delegate = self
        actionsContainerView.addSubview(actionsView)
        
        actionsView.heightAnchor.constraint(equalTo: swipeable.heightAnchor).isActive = true
        actionsView.widthAnchor.constraint(equalTo: swipeable.widthAnchor, multiplier: 2).isActive = true
        actionsView.topAnchor.constraint(equalTo: swipeable.topAnchor).isActive = true
        actionsView.leftAnchor.constraint(equalTo: actionsContainerView.rightAnchor).isActive = true
        
        actionsView.setNeedsUpdateConstraints()
        
        swipeable.actionsView = actionsView
        
        swipeable.state = .dragging
    }
    
    func stopAnimatorIfNeeded() {
        if animator?.isRunning == true {
            animator?.stopAnimation(true)
        }
    }
    
    func animate(duration: Double = 0.7, to offset: CGFloat, with velocity: CGFloat = 0, completion: ((Bool) -> Void)? = nil) {
        stopAnimatorIfNeeded()
        
        swipeable?.layoutIfNeeded()
        
        let animator: LNSwipeAnimator = {
            if velocity != 0 {
                if #available(iOS 10, *) {
                    let velocity = CGVector(dx: velocity, dy: velocity)
                    let parameters = UISpringTimingParameters(mass: 1.0, stiffness: 100, damping: 18, initialVelocity: velocity)
                    return UIViewPropertyAnimator(duration: 0.0, timingParameters: parameters)
                } else {
                    return UIViewSpringAnimator(duration: duration, damping: 1.0, initialVelocity: velocity)
                }
            } else {
                if #available(iOS 10, *) {
                    return UIViewPropertyAnimator(duration: duration, dampingRatio: 1.0)
                } else {
                    return UIViewSpringAnimator(duration: duration, damping: 1.0)
                }
            }
        }()
        
        animator.addAnimations {
            guard let swipeable = self.swipeable,
                let actionsContainerView = self.actionsContainerView
                else {
                    return
            }
            actionsContainerView.center = CGPoint(x: offset, y: actionsContainerView.center.y)
            swipeable.actionsView?.visibleWidth = abs(actionsContainerView.frame.minX)
            swipeable.layoutIfNeeded()
        }
        
        if let completion = completion {
            animator.addCompletion(completion)
        }
        
        self.animator = animator
        
        animator.startAnimation()
    }
    
    func targetState(for velocity: CGPoint) -> LNSwipeState {
        guard let actionsView = swipeable?.actionsView else {
            return .center
        }
        
        if velocity.x > 0 && !actionsView.expanded {
            return .center
        } else {
            return .right
        }
    }
    
    func targetCenter(active: Bool) -> CGFloat {
        guard let swipeable = self.swipeable else {
            return 0
        }
        guard let actionsView = swipeable.actionsView,
            active
            else {
                return swipeable.bounds.midX
        }
        return swipeable.bounds.midX - actionsView.preferredWidth
    }
}

extension LNSwipeController {
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let target = actionsContainerView,
            var swipeable = self.swipeable
            else {
                return
        }
        let velocity = gesture.velocity(in: target)
        
        if delegate?.swipeControllerCanBeginEditingSwipeable(self) == false {
            return
        }
        
        switch gesture.state {
        case .began:
            if let swipeable = scrollView?.swipeables.first(where: { $0.state == .dragging }) as? UIView,
                self.swipeable != nil,
                swipeable != self.swipeable! {
                return
            }
            stopAnimatorIfNeeded()
            
            originalCenter = target.center.x
            
            if swipeable.state == .center || swipeable.state == .animationToCenter {
                showActionsView()
            }
        case .changed:
            guard let actionsView = swipeable.actionsView,
                let actionsContainerView = self.actionsContainerView,
                swipeable.state.isActive
                else {
                    return
            }
            
            if swipeable.state == .animationToCenter {
                let swipedCell = scrollView?.swipeables.first(where: { $0.state == .dragging || $0.state == .left || $0.state == .right }) as? UIView
                if let swipedCell = swipedCell,
                    self.swipeable != nil,
                    swipedCell != self.swipeable! {
                    return
                }
            }
            
            let translation = gesture.translation(in: target).x
            scrollRatio = 1.0
            
            if (translation + originalCenter - swipeable.bounds.midX) > 0 {
                target.center.x = gesture.elasticTranslation(in: target,
                                                             with: .zero,
                                                             fromOriginalCenter: CGPoint(x: originalCenter, y: 0)).x
                swipeable.actionsView?.visibleWidth = abs((swipeable as LNSwipeable).frame.minX)
                scrollRatio = elasticScrollRatio
                return
            }
            
            if let expansionStyle = actionsView.options.expansionsStyle,
                let scrollView = scrollView {
                let referenceFrame = (actionsContainerView != swipeable) ? actionsContainerView.frame : nil
                let expanded = expansionStyle.shouldExoand(view: swipeable, gesture: gesture, in: scrollView, withIn: referenceFrame)
                let targetOffset = expansionStyle.targetOffset(for: swipeable)
                let currentOffset = abs(translation + originalCenter - swipeable.bounds.midX)
                
                if expanded && !actionsView.expanded && targetOffset > currentOffset {
                    let centerForTranslationToEdge = swipeable.bounds.midX - targetOffset
                    let delta = centerForTranslationToEdge - originalCenter
                    
                    animate(to: centerForTranslationToEdge)
                    gesture.setTranslation(CGPoint(x: delta, y: 0), in: swipeable.superview!)
                } else {
                    target.center.x = gesture.elasticTranslation(in: target,
                                                                 with: CGSize(width: targetOffset, height: 0),
                                                                 fromOriginalCenter: CGPoint(x: originalCenter, y: 0),
                                                                 applyingRatio: expansionStyle.targetOverscrollElasticity).x
                    swipeable.actionsView?.visibleWidth = abs(actionsContainerView.frame.minX)
                }
                actionsView.setExpanded(expanded: expanded, feedback: true)
            } else {
                target.center.x = gesture.elasticTranslation(in: target,
                                                             with: CGSize(width: actionsView.preferredWidth, height: 0),
                                                             fromOriginalCenter: CGPoint(x: originalCenter, y: 0),
                                                             applyingRatio: elasticScrollRatio).x
                swipeable.actionsView?.visibleWidth = abs(actionsContainerView.frame.minX)
                
                if (target.center.x - originalCenter) / translation != 1.0 {
                    scrollRatio = elasticScrollRatio
                }
            }
        case .ended, .cancelled, .failed:
            guard let actionsView = swipeable.actionsView,
                let actionsContainerView = self.actionsContainerView
                else {
                    return
            }
            if swipeable.state.isActive == false && swipeable.bounds.midX == target.center.x {
                return
            }
            
            swipeable.state = targetState(for: velocity)
            
            if actionsView.expanded == true,
                let expandedAction = actionsView.expandableAction {
                perform(action: expandedAction)
            } else {
                let targetOffset = targetCenter(active: swipeable.state.isActive)
                let distance = targetOffset - actionsContainerView.center.x
                let normallizedVelocity = velocity.x * scrollRatio / distance
                
                animate(to: targetOffset, with: normallizedVelocity) { (_) in
                    if self.swipeable?.state == .center {
                        self.reset()
                    }
                }
                
                if !swipeable.state.isActive {
                    delegate?.swipeControllerDidEndEditingSwipeable(self)
                }
            }
        default:
            break
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        hideSwipe(animated: true)
    }
    
    @objc private func handleTablePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            hideSwipe(animated: true)
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension LNSwipeController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == tapGestureRecognizer {
            if UIAccessibility.isVoiceOverRunning {
                scrollView?.hideSwipeables()
            }
            
            let swipeCell = scrollView?.swipeables.first(where: {
                $0.state.isActive ||
                    $0.panGestureRecognizer.state == .began ||
                    $0.panGestureRecognizer.state == .changed ||
                    $0.panGestureRecognizer.state == .ended
            })
            return swipeCell == nil ? false : true
        }
        
        if gestureRecognizer == panGestureRecognizer,
            let view = gestureRecognizer.view,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = gestureRecognizer.translation(in: view)
            return abs(translation.y) <= abs(translation.x)
        }
        
        return true
    }
}

// MARK: - LNSwipeActionsViewDelegate
extension LNSwipeController: LNSwipeActionsViewDelegate {
    func swipeActionsView(_ swipeActionsView: LNSwipeActionsView, didSelect action: LNSwipeAction) {
        perform(action: action)
    }
    
    func perform(action: LNSwipeAction) {
        guard let actionsView = swipeable?.actionsView else {
            return
        }
        
        if action == actionsView.expandableAction,
            let expansionStyle = actionsView.options.expansionsStyle {
            actionsView.setExpanded(expanded: true)
            
            switch expansionStyle.completionAnimation {
            case .bounce:
                perform(action: action, hide: true)
            case .fill(let fillOption):
                performFillAction(action: action, fillOptino: fillOption)
            }
        } else {
            perform(action: action, hide: action.hidesWhenSelected)
        }
    }
    
    func perform(action: LNSwipeAction, hide: Bool) {
        guard let indexPath = swipeable?.indexPath else {
            return
        }
        
        if hide {
            hideSwipe(animated: true)
        }
        
        action.handler?(action, indexPath)
    }
    
    func performFillAction(action: LNSwipeAction, fillOptino: LNSwipeExpansionStyle.FillOptions) {
        guard let swipeable = self.swipeable,
            let actionsContainerView = self.actionsContainerView,
            let actionsView = swipeable.actionsView,
            let indexPath = swipeable.indexPath
            else {
                return
        }
        
        let newCenter = swipeable.bounds.midX - swipeable.bounds.width - actionsView.minimumButtonWidth
        
        action.completionHandler = { [weak self] style in
            guard let self = self else {
                return
            }
            action.completionHandler = nil
            
            self.delegate?.swipeControllerDidEndEditingSwipeable(self)
            
            switch style {
            case .delete:
                actionsContainerView.mask = actionsView.createDeletionMask()
                self.delegate?.swipeController(self, didDeleteSwipeableAt: indexPath)
                
                UIView.animate(withDuration: 0.3, animations: {
                    guard let actionsContainerView = self.actionsContainerView else {
                        return
                    }
                    actionsContainerView.center.x = newCenter
                    actionsContainerView.mask?.frame.size.height = 0
                    swipeable.actionsView?.visibleWidth = abs(actionsContainerView.frame.minX)
                    
                    if fillOptino.timing == .after {
                        actionsView.alpha = 0
                    }
                }) { [weak self] (_) in
                    self?.actionsContainerView?.mask = nil
                    self?.resetSwipe()
                    self?.reset()
                }
            case .reset:
                self.hideSwipe(animated: true)
            }
        }
        
        let invokeAction = {
            action.handler?(action, indexPath)
            
            if let style = fillOptino.autoFulFillmentStyle {
                action.fulFill(with: style)
            }
        }
        
        animate(duration: 0.3, to: newCenter) { (_) in
            if fillOptino.timing == .after {
                invokeAction()
            }
        }
        
        if fillOptino.timing == .with {
            invokeAction()
        }
    }
    
    func hideSwipe(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard var swipeable = self.swipeable,
            let actionsContainerView = actionsContainerView,
            swipeable.state == .right
            else {
                return
        }
        guard let actionsView = swipeable.actionsView else {
            return
        }
        
        swipeable.state = .animationToCenter
        
        let targetCenter = self.targetCenter(active: false)
        
        if animated {
            animate(to: targetCenter) { (complete) in
                self.reset()
                completion?(complete)
            }
        } else {
            actionsContainerView.center = CGPoint(x: targetCenter, y: actionsView.center.y)
            swipeable.actionsView?.visibleWidth = abs(actionsContainerView.frame.minX)
            reset()
        }
        
        delegate?.swipeControllerDidEndEditingSwipeable(self)
    }
    
    func resetSwipe() {
        guard let swipeable = self.swipeable,
            let actionsContainerView = self.actionsContainerView
            else {
                return
        }
        
        let targetCenter = self.targetCenter(active: false)
        
        actionsContainerView.center = CGPoint(x: targetCenter, y: actionsContainerView.center.y)
        swipeable.actionsView?.visibleWidth = abs(actionsContainerView.frame.minX)
    }
    
    func showSwipe(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        setSwipeOffset(.greatestFiniteMagnitude * -1, animated: animated, completion: completion)
    }
    
    func setSwipeOffset(_ offset: CGFloat, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard var swipeable = self.swipeable,
            let actionsContainerView = self.actionsContainerView
            else {
                return
        }
        
        if offset != 0 {
            hideSwipe(animated: animated, completion: completion)
            return
        }
        
        let targetState = LNSwipeState.right
        
        if swipeable.state != targetState {
            guard showActionsView() else {
                return
            }
            
            scrollView?.hideSwipeables()
            
            swipeable.state = targetState
        }
        
        let maxOffset = min(swipeable.bounds.width, abs(offset)) * -1
        let targetCenter = abs(offset) == CGFloat.greatestFiniteMagnitude ? self.targetCenter(active: true) : swipeable.bounds.midX + maxOffset
        
        if animated {
            animate(to: targetCenter) { (complete) in
                completion?(complete)
            }
        } else {
            actionsContainerView.center.x = targetCenter
            swipeable.actionsView?.visibleWidth = abs(actionsContainerView.frame.minX)
        }
    }
}
