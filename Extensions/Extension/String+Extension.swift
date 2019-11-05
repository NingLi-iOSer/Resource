//
//  String+Extension.swift
//  ManagementSystem
//
//  Created by Apple on 2018/4/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

extension String {
    
    /// 获取字符串中的 double 数字
    var doubleNumber: Double {
        let scanner = Scanner(string: self)
        var number: Double = 0
        scanner.scanDouble(&number)
        return number
    }
    
    /// MD5 字符串
    var md5String: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
    
    /// 忽略小数点后的0
    var ignoreDecimalZero: String {
        let desc = self as NSString
        let pointLocation = desc.range(of: ".").location
        if pointLocation != NSNotFound && Int(desc.substring(from: pointLocation + 1)) == 0 {
            return desc.substring(with: NSRange(location: 0, length: pointLocation))
        } else {
            return self
        }
    }
    
    /// 拼接沙盒doc路径
    func addDocumentPath() -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = String(format: "%@/%@", docPath, self)
        return filePath
    }
    
    func addSortDataFilePath() -> String {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = String(format: "%@/SortData/%@", docPath, self)
        return filePath
    }
    
    /// 获取字符串长度 - 忽略首尾空格
    func ln_count() -> Int {
        var str = self
        str = str.trimmingCharacters(in: .whitespaces)
        let count = str.count
        return count
    }
    
    /// 获取字符串的真实值, 为空时,返回 nil
    func ln_realString() -> String? {
        let text = self.trimmingCharacters(in: .whitespaces)
        if text.count == 0 {
            return nil
        }
        return text
    }
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result: result, length: digestLen)
        
        result.deallocate()
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>,
                                  length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
    /// 获取子字符串在父字符串中的所有位置
    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    
    /// 设置数字和文字属性文本
    ///
    /// - Parameters:
    ///   - filterCharacters: 需要过滤的字符
    ///   - numberColor: 数字颜色
    ///   - textColor: 文字颜色
    ///   - fontSize: 字体大小
    func ms_numberTextAttr(filterCharacters: [String]?, numberColor: UIColor, textColor: UIColor, fontSize: CGFloat, numberWeight: UIFont.Weight = .regular, textWeight: UIFont.Weight = .regular) -> NSAttributedString? {
        let characters = (filterCharacters ?? []) + [".", ","]
        let attrM = NSMutableAttributedString(string: self)
        
        // 遍历字符串
        for (index, char) in self.enumerated() {
            let ch = String(char)
            let scan: Scanner = Scanner(string: ch)
            
            var val:Int = 0
            
            // 判断是否是数字
            if scan.scanInt(&val) || characters.contains(ch) {
                let range = NSMakeRange(index, 1)
                attrM.addAttributes([NSAttributedString.Key.foregroundColor: numberColor,
                                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: numberWeight)],
                                    range: range)
            } else {
                let range = NSMakeRange(index, 1)
                attrM.addAttributes([NSAttributedString.Key.foregroundColor: textColor,
                                     NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: textWeight)],
                                    range: range)
            }
        }
        
        return (attrM.copy() as? NSAttributedString)
    }
    
    /// 转十六进制
    var hex: uint {
        let scanner = Scanner(string: self)
        var hex: uint = 0
        scanner.scanHexInt32(&hex)
        return hex
    }
    
    /// 生成操作提示语
    var tipMessage: String? {
        let original = self as NSString
        let verbs = ["删除", "禁用", "启用", "取消", "完成", "确认", "接收", "作废"]
        for verb in verbs {
            let range = original.range(of: verb)
            if range.location != NSNotFound {
                let processText = original.substring(with: range)
                let noun = original.substring(from: range.location + range.length)
                return "确定\(processText)该\(noun)吗?"
            }
        }
        return nil
    }
    
    /// 切换单位后更改数字
    ///
    /// - Parameters:
    ///   - source: 原单位
    ///   - to: 目标单位
    func changeUnit(source: MSPurchaseOrderUnit, to: MSPurchaseOrderUnit) -> String? {
        guard let number = Double(self) else {
            return nil
        }
        switch source {
        case .yard:
            return self
        case .meter:
            if to == .yard {
                return Int(number).description
            } else {
                return self
            }
        case .kilogram:
            if to == .yard {
                return Int(number).description
            } else {
                return number.roundTo(places: 1, rule: .down).ignoreDecimalZero
            }
        }
    }
    
    /// 切换单位后更改数字
    ///
    /// - Parameters:
    ///   - source: 原单位
    ///   - to: 目标单位
    func changeNormalWholeUnit(source: MSNormalWholeStockUnit, to: MSNormalWholeStockUnit) -> String? {
        guard let number = Double(self) else {
            return nil
        }
        switch source {
        case .yard, .roll:
            return self
        case .meter:
            if to == .yard || to == .roll {
                return Int(number).description
            } else {
                return self
            }
        case .kilogram:
            if to == .yard || to == .roll {
                return Int(number).description
            } else {
                return number.roundTo(places: 1, rule: .down).ignoreDecimalZero
            }
        }
    }
}

enum CryptoAlgorithm {
    case SHA1
    case SHA224
    case SHA256
    case SHA384
    case SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
