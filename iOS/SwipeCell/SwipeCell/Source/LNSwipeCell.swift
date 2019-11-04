//
//  LNSwipeCell.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class LNSwipeCell: UITableViewCell {
    
    public weak var delegate: LNSwipeTableViewCellDelegate?
    
    var state: LNSwipeState = .center
    var actionsView: LNSwipeActionsView?
    var scrollView: UIScrollView? {
        return tableView
    }
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
    var panGestureRecognizer: UIGestureRecognizer {
        return swipeController.panGestureRecognizer
    }
    
    var swipeController: LNSwipeController!
    var isPreviousSelected = false
    
    weak var tableView: UITableView?
    
    override var frame: CGRect {
        set {
            switch state.isActive {
            case true:
                super.frame = CGRect(origin: CGPoint(x: frame.minX, y: newValue.minY), size: newValue.size)
            case false:
                super.frame = newValue
            }
        }
        get {
            return super.frame
        }
    }
    
    override var layoutMargins: UIEdgeInsets {
        set {
            super.layoutMargins = newValue
        }
        get {
            if frame.origin.x != 0 {
                return swipeController.originalLayoutMargins
            } else {
                return super.layoutMargins
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configure()
    }
    
    deinit {
        tableView?.panGestureRecognizer.removeTarget(self, action: nil)
    }
    
    func configure() {
        clipsToBounds = false
        
        swipeController = LNSwipeController(swipeable: self, actionsContainerView: self)
        swipeController.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
        resetSelectedState()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        var view: UIView = self
        while let superview = view.superview {
            view = superview
            if let tableView = view as? UITableView {
                self.tableView = tableView
                
                swipeController.scrollView = tableView
                
                tableView.panGestureRecognizer.removeTarget(self, action: nil)
                tableView.panGestureRecognizer.addTarget(self, action: #selector(handleTablePan(_:)))
                return
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            hideSwipe(animated: false)
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let superview = superview else {
            return false
        }
        let point = convert(point, to: superview)
        
        if !UIAccessibility.isVoiceOverRunning {
            for cell in tableView?.swipeCells ?? [] {
                if cell.state == .right && !cell.contains(point: point) {
                    tableView?.hideSwipeCell()
                    return false
                }
            }
        }
        return contains(point: point)
    }
    
    func contains(point: CGPoint) -> Bool {
        return point.y > frame.minY && point.y < frame.maxY
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if state == .center {
            super.setHighlighted(highlighted, animated: animated)
        }
        
    }
    
    @objc private func handleTablePan(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            hideSwipe(animated: true)
        }
    }
    
    func reset() {
        swipeController.reset()
        clipsToBounds = false
    }
    
    func resetSelectedState() {
        if isPreviousSelected {
            if let tableView = tableView,
                let indexPath = tableView.indexPath(for: self) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        isPreviousSelected = false
    }
}

extension LNSwipeCell {
    public var swipeOffset: CGFloat {
        set {
            setSwipeOffset(newValue, animated: false)
        }
        get {
            return frame.midX - bounds.midX
        }
    }
    
    public func hideSwipe(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        swipeController.hideSwipe(animated: animated, completion: completion)
    }
    
    public func showSwipe(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        setSwipeOffset(.greatestFiniteMagnitude * -1, animated: animated, completion: completion)
    }
    
    public func setSwipeOffset(_ offset: CGFloat, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        swipeController.setSwipeOffset(offset, animated: animated, completion: completion)
    }
}

extension LNSwipeCell {
    override func accessibilityElementCount() -> Int {
        guard state != .center else {
            return super.accessibilityElementCount()
        }
        return 1
    }
    
    override func accessibilityElement(at index: Int) -> Any? {
        guard state != .center else {
            return super.accessibilityElement(at: index)
        }
        return actionsView
    }
    
    override func index(ofAccessibilityElement element: Any) -> Int {
        guard state != .center else {
            return super.index(ofAccessibilityElement: element)
        }
        return element is LNSwipeActionsView ? 0 : NSNotFound
    }
    
    override var accessibilityCustomActions: [UIAccessibilityCustomAction]? {
        set {
            super.accessibilityCustomActions = newValue
        }
        get {
            guard let tableView = tableView,
                let indexPath = tableView.indexPath(for: self)
                else {
                    return super.accessibilityCustomActions
            }
            
            let actions = delegate?.tableView(tableView, editActionsForRowAt: indexPath) ?? []
            if actions.isEmpty {
                return super.accessibilityCustomActions
            } else {
                return actions.compactMap { LNSwipeAccessibilityCustomAction(action: $0,
                                                                             indexPath: indexPath,
                                                                             target: self,
                                                                             selector: #selector(performAccessibilityCustomAction(accessibilityCustomAction:))) }
            }
        }
    }
    
    @objc private func performAccessibilityCustomAction(accessibilityCustomAction: LNSwipeAccessibilityCustomAction) -> Bool {
        guard let tableView = tableView else {
            return false
        }
        
        let swipeAction = accessibilityCustomAction.action
        
        swipeAction.handler?(swipeAction, accessibilityCustomAction.indexPath)
        
        if swipeAction.style == .destructive {
            tableView.deleteRows(at: [accessibilityCustomAction.indexPath], with: .fade)
        }
        
        return true
    }
}

// MARK: - LNSwipeControllerDelegate
extension LNSwipeCell: LNSwipeControllerDelegate {
    func swipeControllerCanBeginEditingSwipeable(_ controller: LNSwipeController) -> Bool {
        return self.isEditing == false
    }
    
    func swipeControllerEditActionsForSwipeable(_ controller: LNSwipeController) -> [LNSwipeAction]? {
        guard let tableView = tableView,
            let indexPath = tableView.indexPath(for: self)
            else {
                return nil
        }
        return delegate?.tableView(tableView, editActionsForRowAt: indexPath)
    }
    
    func swipeControllerEditActionsOptionsForSwipeable(_ controller: LNSwipeController) -> LNSwipeOptions {
        guard let tableView = tableView,
            let indexPath = tableView.indexPath(for: self)
            else {
                return LNSwipeOptions()
        }
        return delegate?.tableView(tableView, editActionsOptionsForRowAt: indexPath) ?? LNSwipeOptions()
    }
    
    func swipeControllerWillBeginEditingSwipeable(_ controller: LNSwipeController) {
        guard let tableView = tableView,
            let indexPath = tableView.indexPath(for: self)
            else {
                return
        }
        super.setHighlighted(false, animated: false)
        isPreviousSelected = isSelected
        tableView.deselectRow(at: indexPath, animated: false)
        
        delegate?.tableView(tableView, willBeginEditingRowAt: indexPath)
    }
    
    func swipeControllerDidEndEditingSwipeable(_ controller: LNSwipeController) {
        guard let tableView = tableView,
            let indexPath = tableView.indexPath(for: self)
            else {
                return
        }
        resetSelectedState()
        delegate?.tableView(tableView, didEndEditingRowAt: indexPath)
    }
    
    func swipeController(_ controller: LNSwipeController, didDeleteSwipeableAt indexPath: IndexPath) {
        tableView?.deleteRows(at: [indexPath], with: .none)
    }
    
    func swipeController(_ controller: LNSwipeController, visiableRectFor scrollView: UIScrollView) -> CGRect? {
        guard let tableView = tableView else {
            return nil
        }
        return delegate?.visibleRect(for: tableView)
    }
}
