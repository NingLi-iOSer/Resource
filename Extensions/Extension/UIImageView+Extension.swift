//
//  UIImageView+Extension.swift
//  ManagementSystem
//
//  Created by Ning Li on 2019/5/16.
//  Copyright © 2019 Apple. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    /// 设置图片
    ///
    /// - Parameters:
    ///   - URLString: URLString
    ///   - placeholder: 加载占位图片
    ///   - failure: 加载失败图片
    ///   - empty: 无图占位
    ///   - isRoundCorner: 圆角
    func ms_setImage(with URLString: String?, placeholder: UIImage, failure: UIImage?, empty: UIImage?, isRoundCorner: Bool = false, cornerRadius: CGFloat = 4) {
        guard let URLString = URLString,
            let imageURL = URL(string: URLString)
            else {
                image = empty ?? placeholder
                return
        }
        let size = bounds.size
        sd_setImage(with: imageURL, placeholderImage: placeholder, options: []) { [weak self] (image, _, _, _) in
            if let image = image {
                if isRoundCorner {
                    self?.image = image.roundCornerImage(size: size, cornerRadius: nil)
                } else {
                    self?.image = image.scaled(to: self?.bounds.size ?? CGSize(), cornerRadius: cornerRadius)
                }
            } else {
                self?.image = failure
            }
        }
    }
    
    /// 图片缩放后的 frame
    var contentRect: CGRect {
        guard let image = image else {
            return bounds
        }
        let imageRatio = image.size.width / image.size.height
        let viewRatio = bounds.width / bounds.height
        if imageRatio < viewRatio {
            let scale = bounds.height / image.size.height
            let width = scale * image.size.width
            let imageX = (bounds.width - width) * 0.5
            return CGRect(x: imageX, y: 0, width: width, height: bounds.height)
        } else {
            let scale = bounds.width / image.size.width
            let height = scale * image.size.height
            let imageY = (bounds.height - height) * 0.5
            return CGRect(x: 0, y: imageY, width: bounds.width, height: height)
        }
    }
}
