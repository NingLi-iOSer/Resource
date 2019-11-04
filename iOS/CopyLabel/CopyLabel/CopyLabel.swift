//
//  CopyLabel.swift
//  CopyLabel
//
//  Created by Ning Li on 2019/10/31.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class CopyLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isUserInteractionEnabled = true
//        UIActivityIndicatorView
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognize(gesture:)))
        addGestureRecognizer(longPress)
    }
    
    @objc private func longPressRecognize(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            let menuVC = UIMenuController.shared
            let copyItem = UIMenuItem(title: "Copy", action: #selector(copyText))
            menuVC.menuItems = [copyItem]
//            menuVC.update()
            becomeFirstResponder()
            let point = gesture.location(in: self)
            menuVC.showMenu(from: self, rect: CGRect(origin: point, size: CGSize.zero))
        default:
            break
        }
    }
    
    @objc private func copyText() {
        let board = UIPasteboard.general
        board.string = text
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyText) {
            return true
        }
        return false
    }
}
