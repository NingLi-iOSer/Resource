//
//  WKWebView+Extension.swift
//  ManagementSystem
//
//  Created by Ning Li on 2019/8/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import WebKit

extension WKWebView {
    
    /// 滚动截图
    ///
    /// - Parameter complete: 完成回调
    func shotContentScrollCapture(imageBackgroundColor: UIColor? = nil, complete: @escaping (_ image: UIImage?) -> Void) {
        // Put a fake Cover of View
        let snapShotView = self.snapshotView(afterScreenUpdates: true)
        snapShotView?.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (snapShotView?.frame.size.width)!, height: (snapShotView?.frame.size.height)!)
        self.superview?.addSubview(snapShotView!)
        
        let originalBackgroundColor = backgroundColor
        if imageBackgroundColor != nil {
            self.backgroundColor = imageBackgroundColor
        }
        
        // Backup
        let bakOffset = self.scrollView.contentOffset
        
        // Divide
        let page: Float
        if scrollView.contentSize.width > scrollView.bounds.width {
            page = floorf(Float(self.scrollView.contentSize.width / self.bounds.width))
        } else {
            page = floorf(Float(self.scrollView.contentSize.height / self.bounds.height))
        }
        
        UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, false, UIScreen.main.scale)
        
        self.shotScreenContentScrollPageDraw(0, maxIndex: Int(page), drawCallback: { [weak self] () -> Void in
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            self?.backgroundColor = originalBackgroundColor
            // Recover
            self?.scrollView.setContentOffset(bakOffset, animated: false)
            snapShotView?.removeFromSuperview()
            
            complete(capturedImage)
        })
    }
    
    private func shotScreenContentScrollPageDraw (_ index: Int, maxIndex: Int, drawCallback: @escaping () -> Void) {
        
        let splitFrame: CGRect
        if scrollView.contentSize.width > scrollView.bounds.width { // 横向滚动
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.scrollView.frame.size.width, y: 0), animated: false)
            splitFrame = CGRect(x: CGFloat(index) * self.scrollView.frame.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)
        } else { // 纵向滚动
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.scrollView.frame.size.height, y: 0), animated: false)
            splitFrame = CGRect(x: 0, y: CGFloat(index) * self.scrollView.frame.size.height, width: bounds.size.width, height: bounds.size.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            self.drawHierarchy(in: splitFrame, afterScreenUpdates: true)
            
            if index < maxIndex {
                self.shotScreenContentScrollPageDraw(index + 1, maxIndex: maxIndex, drawCallback: drawCallback)
            }else{
                drawCallback()
            }
        }
    }
}
