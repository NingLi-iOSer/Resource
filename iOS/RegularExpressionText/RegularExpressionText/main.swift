//
//  main.swift
//  RegularExpressionText
//
//  Created by Ning Li on 2019/4/30.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Foundation

var str = "@u李宁@u于@c(FF9000)04-27 09:49@c采购入库，数量：0米。"

let pattern = "@c"
let regx = try? NSRegularExpression(pattern: pattern, options: [])

let results = regx?.matches(in: str, options: [], range: NSMakeRange(0, str.count))

if let res = results,
    res.count == 2 {
    let firstRange = res.first!.range
    let lastRange = res.last!.range
    let range = NSMakeRange(firstRange.length + firstRange.location, lastRange.location - firstRange.location - firstRange.length)
    
    let colorText = (str as NSString).substring(with: range)
    let color = (colorText as NSString).substring(with: NSMakeRange(1, 6))
    let text = (colorText as NSString).substring(from: 8)
    
    print(color, text)
}
