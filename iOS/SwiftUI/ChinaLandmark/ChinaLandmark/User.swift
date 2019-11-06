//
//  User.swift
//  ChinaLandmark
//
//  Created by Ning Li on 2019/11/6.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Foundation

struct User {
    var userName: String
    var prefersNotifications: Bool = true
    var prefersSeason: Season = .spring
    var birthday = Date()
    
    static let `default` = Self(userName: "Profile")
    
    enum Season: String, CaseIterable {
        case spring = "🌹"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "❄️"
    }
}
