//
//  LNSwipeFeedback.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/26.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

final class LNSwipeFeedback {
    enum Style {
        case light
        case medium
        case heavy
    }
    
    private var _feedbackGenerator: Any?
    
    @available(iOS 10.0.1, *)
    private var feedbackGenerator: UIImpactFeedbackGenerator? {
        set {
            _feedbackGenerator = newValue
        }
        get {
            return _feedbackGenerator as? UIImpactFeedbackGenerator
        }
    }
    
    init(style: Style) {
        if #available(iOS 10.0.1, *) {
            switch style {
            case .light:
                feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            case .medium:
                feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            case .heavy:
                feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
            }
        } else {
            _feedbackGenerator = nil
        }
    }
    
    func prepare() {
        if #available(iOS 10.0.1, *) {
            feedbackGenerator?.prepare()
        }
    }
    
    func impactOccurred() {
        if #available(iOS 10.0.1, *) {
            feedbackGenerator?.impactOccurred()
        }
    }
}
