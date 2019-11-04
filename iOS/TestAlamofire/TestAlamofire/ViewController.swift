//
//  ViewController.swift
//  TestAlamofire
//
//  Created by Ning Li on 2019/9/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = """
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJDTEFJTV9LRVlfUExBVEZPUk1fS0VZIjoyMCwiQ0xBSU1fS0VZX1VTRVJfSUQiOjYsImV4cCI6MTU2NTgzNjE1MX0.QKK8yOLN9MyAwLY1a6kMepkajLIwYySvuO-1zaoXjpQ
"""
        NetworkManager.shared.authorizationToken = token
//        NetworkManager.shared.request(URLString: "/app/grayVariety/pageList", parameters: nil) { (isSuccess, errorInfo) in
//
//        }
        
        NetworkManager.shared.requestListData(URLString: "/app/grayVariety/pageList", parameters: nil) { (data, errorInfo) in
            if let data = data {
                let content = try? JSONSerialization.jsonObject(with: data, options: [])
                print(content)
            } else {
                print(errorInfo)
            }
        }
    }
}

