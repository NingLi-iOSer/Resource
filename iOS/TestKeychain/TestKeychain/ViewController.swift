//
//  ViewController.swift
//  TestKeychain
//
//  Created by Ning Li on 2019/6/24.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return
        }
        print("bundle ID: \(bundleID)")
        if let uuid = SAMKeychain.password(forService: bundleID, account: bundleID) {
            print(uuid)
        } else {
            let uuid = UUID().uuidString
            SAMKeychain.setPassword(uuid, forService: bundleID, account: bundleID)
            print(uuid)
        }
        
        // 34105A29-F3D4-47A2-8A83-ABE331B21D46
    }


}

