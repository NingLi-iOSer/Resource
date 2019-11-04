//
//  ViewController.swift
//  TestDarkMode
//
//  Created by Ning Li on 2019/7/2.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = UIColor(named: "Color")
        textLabel.textColor = UIColor(named: "TextColor")
    }
}

