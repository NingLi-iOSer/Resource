//
//  Double+Extension.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/9/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

extension Double {
    /// 保留小数位
    ///
    /// - Parameter places: 小数位数
    func roundTo(places: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> String {
        let divisor = pow(10.0, Double(places))
        let str = String(format: "%.\(places)lf", (self * divisor).rounded(rule) / divisor)
        return str
    }
    
    func round(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        let result = (self * divisor).rounded() / divisor
        return result
    }
    
    /// 忽略小数点后的0
    var ignoreDecimalZero: String {
        let desc = self.description as NSString
        let pointLocation = desc.range(of: ".").location
        if Int(desc.substring(from: pointLocation + 1)) == 0 {
            return desc.substring(with: NSRange(location: 0, length: pointLocation))
        } else {
            return desc as String
        }
    }
    
    var decimalZero: String {
        let desc = self.description as NSString
        let pointLocation = desc.range(of: ".").location
        if Int(desc.substring(from: pointLocation + 1)) == 0 {
            return desc.substring(with: NSRange(location: 0, length: pointLocation + 2))
        } else {
            return desc as String
        }
    }
}
