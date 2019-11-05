//
//  UIImage+Extension.swift
//  ManagementSystem
//
//  Created by Apple on 2018/4/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

/// 图片格式
enum ImageType{
    case jpg
    case png
    case tiff
    case gif
    case webp
    case bmp
    case none
}

extension UIImage {
    /// 处理图像圆角
    ///
    /// - Parameters:
    ///   - backColor: 背景颜色
    ///   - cornerRadius: 圆角半径
    func roundCornerImage(size: CGSize?, backColor: UIColor = UIColor.clear, cornerRadius: CGFloat?) -> UIImage {
        let imageSize: CGSize
        if size != nil {
            if self.size.height > self.size.width {
                let height = self.size.height / self.size.width * size!.width
                imageSize = CGSize(width: size!.width, height: height)
            } else {
                let width = self.size.width / self.size.height * size!.height
                imageSize = CGSize(width: width, height: size!.height)
            }
        } else {
            imageSize = self.size
        }
        let radius = cornerRadius ?? imageSize.width * 0.5
        let rect = CGRect(origin: CGPoint(), size: imageSize)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)

        backColor.setFill()
        UIRectFill(rect)

        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.addClip()

        self.draw(in: rect)

        let result = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        return result!
    }
    
    /// 图片类型
    var type: ImageType {
        let data = pngData()! as NSData
        var c:UInt8?
        data.getBytes(&c, length: 1)
        switch c {
        case 0xFF:
            return ImageType.jpg
        case 0x89:
            return ImageType.png
        case 0x47:
            return ImageType.gif
        case 0x49,0x4D:
            return ImageType.tiff
        case 0x42:
            return ImageType.bmp
        case 0x52:
            if (data.length < 12) {
                return ImageType.none
            }
            let testString:NSString = NSString(data: data.subdata(with: NSMakeRange(0, 12)), encoding: String.Encoding.ascii.rawValue)!
            if testString.hasPrefix("RIFF"),testString.hasSuffix("WEBP") {
                return ImageType.webp
            }
        default:
            return ImageType.none
        }
        return ImageType.none
    }
    
    /// 灰度图片
    var grayImage: UIImage? {
        let size =  self.size
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        if context == nil {
            return nil
        }
        context?.draw(self.cgImage!, in: CGRect(origin: CGPoint(), size: size))
        if let cgImage = context?.makeImage() {
            let result = UIImage(cgImage: cgImage)
            return result
        }
        return nil
    }
    
    func scaled(to newSize: CGSize, cornerRadius: CGFloat = 0) -> UIImage? {
        //计算比例
        let aspectWidth  = newSize.width / size.width
        let aspectHeight = newSize.height / size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        //图片绘制区域
        let scaledImageRect = CGRect(x: (newSize.width - size.width * aspectRatio) * 0.5,
                                     y: (newSize.height - size.height * aspectRatio) * 0.5,
                                     width: size.width * aspectRatio,
                                     height: size.height * aspectRatio)
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if cornerRadius > 0 {
            return scaledImage?.roundCornerImage(size: nil, cornerRadius: cornerRadius)
        } else {
            return scaledImage
        }
    }
}
