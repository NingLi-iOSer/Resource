//
//  ViewController.swift
//  SingleDraggable
//
//  Created by Ning Li on 2019/3/27.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.signleDragable()
    }
}

