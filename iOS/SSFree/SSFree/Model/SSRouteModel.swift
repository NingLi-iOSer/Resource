//
//  SSRouteModel.swift
//  SSFree
//
//  Created by Ning Li on 2019/12/17.
//  Copyright © 2019 Ning Li. All rights reserved.
//

struct SSRouteModel: Codable {
    var ip_address: String
    var port: String
    var password: String
    var encryptionType: String
    
    init(ip_address: String, port: String, password: String, encryptionType: String) {
        self.ip_address = ip_address
        self.port = port
        self.password = password
        self.encryptionType = encryptionType
    }
}
