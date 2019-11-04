//
//  ViewController.swift
//  Airbnb-lottie
//
//  Created by Ning Li on 2019/5/27.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {
    
    private lazy var animView = AnimationView(name: "animation")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animView.bounds.size = CGSize(width: 100, height: 100)
        animView.loopMode = .loop
        view.addSubview(animView)
        
        animView.play()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animView.center = view.center
    }
}

