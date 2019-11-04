//
//  ViewController.swift
//  CustomPopAnim
//
//  Created by Ning Li on 2019/7/18.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func push() {
        navigationController?.ln_pushViewController(DetailViewController())
    }
    
}

