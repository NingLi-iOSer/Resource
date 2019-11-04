//
//  LNPlayerControlBarDelegate.swift
//  Player
//
//  Created by Ning Li on 2019/3/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNPlayerControlBarDelegate: class {

    /// 开始播放
    ///
    /// - Parameter playControlBar: LNPlayerControlBar
    func playControlBarStartPlay(_ playControlBar: LNPlayerControlBar)
    
    /// 暂停
    ///
    /// - Parameter playControlBar: LNPlayerControlBar
    func playControlBarPause(_ playControlBar: LNPlayerControlBar)
    
    /// 全屏
    ///
    /// - Parameter playControlBar: LNPlayerControlBar
    func playControlBarEnterFullScreen(_ playControlBar: LNPlayerControlBar)
    
    /// 退出全屏
    ///
    /// - Parameter playControlBar: LNPlayerControlBar
    func playControlBarExitFullScreen(_ playControlBar: LNPlayerControlBar)
    
    /// 开始更改播放进度
    ///
    /// - Parameter playControlBar: LNPlayerControlBar
    func playControlBarStartChangePlayProgress(_ playControlBar: LNPlayerControlBar)
    
    /// 更改播放进度结束
    ///
    /// - Parameters:
    ///   - playControlBar: LNPlayerControlBar
    ///   - progress: 播放进度
    func playControlBar(_ playControlBar: LNPlayerControlBar, changedEnd progress: Float)
}

extension LNPlayerControlBarDelegate {
    
    func playControlBarStartPlay(_ playControlBar: LNPlayerControlBar) {}
    func playControlBarPause(_ playControlBar: LNPlayerControlBar) {}
    
    func playControlBarEnterFullScreen(_ playControlBar: LNPlayerControlBar) {}
    func playControlBarExitFullScreen(_ playControlBar: LNPlayerControlBar) {}
    
    func playControlBarStartChangePlayProgress(_ playControlBar: LNPlayerControlBar) {}
    func playControlBar(_ playControlBar: LNPlayerControlBar, changedEnd progress: Float) {}
}
