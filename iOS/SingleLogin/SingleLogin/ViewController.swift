//
//  ViewController.swift
//  SingleLogin
//
//  Created by Ning Li on 2019/7/2.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UASDKLogin.share.registerAppId("300011910547", appKey: "01770C025230E3C3830F498117C21A95")
        
//        let webView = UIWebView()
//        let request = URLRequest(url: URL(string: "https://www.baidu.com")!)
//        webView.loadRequest(request)
    }


}

