//
//  ViewController.swift
//  TestStaticFramework
//
//  Created by Ning Li on 2019/8/19.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import AFNetworking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
    }


}

