//
//  PlayerViewController.swift
//  VideoPlayer
//
//  Created by Ning Li on 2019/10/24.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import IJKMediaFramework

class PlayerViewController: UIViewController {
    
    var player: IJKFFMoviePlayerController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let options = IJKFFOptions.byDefault()
        // 开启硬解
        options?.setPlayerOptionIntValue(1, forKey: "videotoolbox")
        let url = URL(string: "http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8")!
        player = IJKFFMoviePlayerController(contentURL: url, with: options)
        
        var arm1 = UIView.AutoresizingMask(rawValue: 0)
        arm1.insert(UIView.AutoresizingMask.flexibleWidth)
        arm1.insert(UIView.AutoresizingMask.flexibleHeight)
        player?.view.autoresizingMask = arm1
        player?.view.backgroundColor = UIColor.orange
        player?.view.frame = UIScreen.main.bounds
        player?.scalingMode = .aspectFit
        player?.shouldAutoplay = true
        view.autoresizesSubviews = true
        view.addSubview(player!.view!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        player?.prepareToPlay()
        player?.play()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player?.shutdown()
    }
}
