//
//  ViewController.swift
//  LoadAnim
//
//  Created by Ning Li on 2018/12/13.
//  Copyright © 2018 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        MSLoadAnimation.show(inView: view)
        MSLoadAnimation.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

