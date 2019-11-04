//
//  ViewController.swift
//  CopyLabel
//
//  Created by Ning Li on 2019/10/31.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = CopyLabel(frame: CGRect(x: 100, y: 200, width: 100, height: 24))
        label.text = "Text Copy"
        view.addSubview(label)
    }


}

