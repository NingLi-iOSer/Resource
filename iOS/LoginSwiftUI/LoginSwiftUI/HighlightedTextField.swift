//
//  HighlightedTextField.swift
//  LoginSwiftUI
//
//  Created by Ning Li on 2019/9/30.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import SwiftUI
import Combine

struct HighlightedTextField: View {
    
    @Binding var phone: String
    @State var isFocus: Bool = false
    var prefixImage: String?
//    var formatter: CustomNumberFormatter
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", value: $phone, formatter: LengthFormatter(), onEditingChanged: { (flag) in
                self.isFocus = flag
            })
                .padding(.leading, prefixImage == nil ? 0 : 38)
                .frame(height: 44)
                .background(Color.white)
                .cornerRadius(6)
            .lineLimit(11)
                .textContentType(.creditCardNumber)
                .onTapGesture {
            }
            if prefixImage != nil {
                Image(prefixImage!)
                .frame(width: 38)
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 6).stroke(lineWidth: isFocus ? 0 : 0.5).foregroundColor(Color(hue: 0, saturation: 0, brightness: 0.59)))
        .shadow(color: isFocus ? Color.black.opacity(0.25) : Color.clear, radius: 6, x: 0, y: 2)
    }
}

class LengthFormatter: Formatter {
    
    //Required overrides
    
    override func string(for obj: Any?) -> String? {
        if obj == nil { return nil }
        
        if let str = (obj as? String) {
            return String(str.prefix(10))
        }
        return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        
        obj?.pointee = String(string.prefix(10)) as AnyObject
        error?.pointee = nil
        return true
    }
    
}
 
final class CustomNumberFormatter: Formatter {
    
    var lengthLimit: Int = 20
    
    init(length: Int) {
        super.init()
        self.lengthLimit = length
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func string(for obj: Any?) -> String? {
        if obj == nil { return nil }

        if let str = (obj as? String) {
            let expression = "^[0-9]{0,\(lengthLimit)}?$"
            let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
            let numberOfMatches = regex.numberOfMatches(in: str, options: .reportProgress, range: NSMakeRange(0, str.count))
            if (numberOfMatches != 0) {
                return str
            } else {
                return String(str.dropLast())
            }
        }
          return nil
    }
    
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        let expression = "^[0-9]{0,\(lengthLimit)}?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: string, options: .reportProgress, range: NSMakeRange(0, string.count))
        if (numberOfMatches != 0) {
            obj?.pointee = string as AnyObject
        } else {
            obj?.pointee = String(string.dropLast()) as AnyObject
        }
        error?.pointee = nil
        return true
    }
}
