//
//  UIScrollView+Extension.swift
//  SwiftLint
//
//  Created by Ning Li on 2019/4/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

extension UIScrollView {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        endEditing(true)
    }
}
