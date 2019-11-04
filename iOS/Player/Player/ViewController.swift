//
//  ViewController.swift
//  Player
//
//  Created by Ning Li on 2019/3/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private weak var player: LNPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let player = LNPlayer(videoURL: "http://flv2.bn.netease.com/videolib3/1605/05/JgIvk8807/SD/JgIvk8807-mobile.mp4",
                              frame: CGRect(x: 0, y: 20, width: view.bounds.width, height: 240))
        self.player = player
        view.addSubview(player)
    }
}

