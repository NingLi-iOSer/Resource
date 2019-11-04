//
//  DispatchQueue+Extension.swift
//  WatchWeatherKit
//
//  Created by Ning Li on 2019/10/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    private static var onceToken = [String]()
    
    public class func once(token: String, execute work: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        if onceToken.contains(token) {
            return
        }
        onceToken.append(token)
        work()
    }
}
