//
//  Tools.swift
//  LoginSwiftUI
//
//  Created by Ning Li on 2019/9/30.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Foundation

enum NumberType {
    case integer
    case decimal
}

struct Tools {
    
    static func validateNumber(_ number: String, type: NumberType, limit: Int = 50) -> Bool {
        let expression: String
        switch type {
        case .integer:
            expression = "^[0-9]*((\\.|,)[0-9]{0,\(limit)})?$"
        case .decimal:
            expression = "^[0-9]{0,\(limit)}?$"
        }
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: number, options: .reportProgress, range: NSMakeRange(0, number.count))
        return (numberOfMatches != 0)
    }
}
