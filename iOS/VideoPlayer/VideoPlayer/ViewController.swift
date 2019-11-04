//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Ning Li on 2019/10/24.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = PlayerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

