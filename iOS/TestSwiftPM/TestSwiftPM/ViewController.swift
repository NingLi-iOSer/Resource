//
//  ViewController.swift
//  TestSwiftPM
//
//  Created by Ning Li on 2019/12/3.
//  Copyright © 2019 yzh. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("https://www.baidu.com").responseString { (result) in
            
        }
    }


}

