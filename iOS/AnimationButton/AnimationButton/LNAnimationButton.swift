//
//  LNAnimationButton.swift
//  AnimationButton
//
//  Created by Ning Li on 2018/12/25.
//  Copyright © 2018 Ning Li. All rights reserved.
//

import UIKit

enum LNAnimationStatus: Int {
    case normal     = 0
    case loading    = 1
    case success    = 2
    case failure    = 3
}

class LNAnimationButton: UIView {
    
    var status: LNAnimationStatus = .normal {
        didSet {
            animView.status = status
            titleLabel.text = titles[status.rawValue]
            titleLabel.sizeToFit()
        }
    }
    
    private lazy var animView = LNAnimationView()
    
    private lazy var titles = Array(repeating: "", count: 4)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settingUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingUI() {
        animView.delegate = self
        addSubview(titleLabel)
        addSubview(animView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleWidth = titleLabel.bounds.width
        let contentWidth = titleWidth + bounds.height
        animView.frame = CGRect(x: (bounds.width - contentWidth) * 0.5,
                                y: 12,
                                width: bounds.height - 24,
                                height: bounds.height - 24)
        if status == .normal {
            titleLabel.frame = CGRect(x: (bounds.width - titleWidth) * 0.5,
                                      y: 0,
                                      width: titleWidth,
                                      height: bounds.height)
        } else {
            titleLabel.frame = CGRect(x: animView.frame.maxX + 10,
                                      y: 0,
                                      width: titleWidth,
                                      height: bounds.height)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if status == .normal {
            status = .loading
        } else {
            status = .normal
        }
    }
    
    /// 设置标题
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - status: 状态
    func setTitle(_ title: String?, status: LNAnimationStatus) {
        titles[status.rawValue] = title ?? ""
        if status == .normal {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }
}

// MARK: - LNAnimationViewDelegate
extension LNAnimationButton: LNAnimationViewDelegate {
    func animationDidStart(_ animationView: LNAnimationView) {
        isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.status = .success
        }
    }
    
    func animationDidStop(_ animationView: LNAnimationView) {
        isUserInteractionEnabled = true
    }
}
