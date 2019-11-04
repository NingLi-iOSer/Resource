//
//  LNPlayer.swift
//  Player
//
//  Created by Ning Li on 2019/3/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

private let kChangeProgressMaxValue: Double = 300

class LNPlayer: UIView {
    
    private var videoURL: String = ""
    private var isStartPlay: Bool = false
    /// 未全屏时的 frame
    private var originalFrame = CGRect()
    private var originalWindowLevel: UIWindow.Level!
    /// 正在更改播放进度
    private var isChangePlayProgress: Bool = false
    /// 播放状态
    private var status: LNPlayerStatus = .pause
    /// 记录父视图
    private weak var superView: UIView?
    /// 全屏标记
    private var isFullScreen: Bool = false
    /// 正在滑动
    private var isDragging: Bool = false
    /// 水平滑动标记
    private var isDraggingHorizontal: Bool = false
    /// touch 初始位置
    private var originalTouchPoint = CGPoint()
    /// touch 初始音量
    private var originalVolumn: Float = 0
    /// touch 初始亮度
    private var originalBrightness: CGFloat = 0
    /// 音量修改提示
    private var volumnView = MPVolumeView(frame: CGRect())
    /// 音量修改滑块
    private weak var volumeSlider: UISlider?
    /// 调节播放进度提示
    private lazy var changeProgressTipLabel = UILabel(text: nil, frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 140, height: 60)), fontSize: 20, textColor: UIColor.white)
    /// 调节播放进度结束时间
    private var changeProgressResultTime: Double = 0
    
    private var videoPlayer: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerLayer: AVPlayerLayer?
    
    private lazy var indicator = UIActivityIndicatorView(style: .white)
    
    /// 播放按钮
    private lazy var playButton: UIButton = {
        let button = UIButton()
        let bundlePath = Bundle.main.path(forResource: "ImageBundle", ofType: "bundle")!
        let bundle = Bundle(path: bundlePath)!
        button.setImage(UIImage(named: "video_play_btn_bg", in: bundle, compatibleWith: nil), for: .normal)
        button.sizeToFit()
        button.isHidden = true
        button.addTarget(self, action: #selector(play(sender:)), for: .touchUpInside)
        return button
    }()
    /// 播放控制
    private lazy var playControl = LNPlayerControlBar(frame: CGRect(x: 0, y: bounds.height, width: bounds.width, height: 0))
    
    convenience init(videoURL: String, frame: CGRect = CGRect(origin: CGPoint.zero, size: CGSize())) {
        self.init(frame: frame)
        self.videoURL = videoURL
        self.backgroundColor = UIColor.black
        self.clipsToBounds = true
        
        initVideoPlayer()
        addPlayerItemObserver()
        setupUI()
        initGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        indicator.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        playButton.center = indicator.center
        
        if playControl.isHidden {
            playControl.frame.origin.y = bounds.height
        } else {
            playControl.frame.origin.y = bounds.height - playControl.bounds.height
        }
        playControl.frame.size.width = bounds.width
        changeProgressTipLabel.center = indicator.center
    }
    
    deinit {
        removePlayerItemObserver()
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - init
private extension LNPlayer {
    /// 初始化播放器
    func initVideoPlayer() {
        guard let url = URL(string: videoURL) else {
            return
        }
        let asset = AVAsset(url: url)
        playerItem = AVPlayerItem(asset: asset)
        videoPlayer = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer?.frame = bounds
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
    }
    
    /// 设置界面
    func setupUI() {
        indicator.startAnimating()
        addSubview(indicator)
        addSubview(playButton)
        
        addSubview(playControl)
        playControl.isHidden = true
        playControl.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(playCompleted), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        volumnView.subviews.forEach { (v) in
            if v.isKind(of: UISlider.self) {
                volumeSlider = v as? UISlider
            }
        }
        
        addSubview(changeProgressTipLabel)
        changeProgressTipLabel.isHidden = true
        changeProgressTipLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        changeProgressTipLabel.layer.cornerRadius = 6
        changeProgressTipLabel.layer.masksToBounds = true
    }
    
    /// 添加手势
    func initGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(singleTapPlayer(tap:)))
        addGestureRecognizer(tap)
    }
}

// MARK: - Gesture
extension LNPlayer {
    /// 点击播放器
    @objc private func singleTapPlayer(tap: UITapGestureRecognizer) {
        let tapPoint = tap.location(in: self)
        if !isStartPlay || playControl.frame.contains(tapPoint) {
            return
        }
        
        if playControl.isHidden {
            playControl.isHidden = false
            UIView.animate(withDuration: 0.25) {
                self.playControl.frame.origin.y -= self.playControl.bounds.height
                self.playControl.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.playControl.frame.origin.y += self.playControl.bounds.height
                self.playControl.alpha = 0
            }) { (_) in
                self.playControl.isHidden = true
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self),
            !playControl.frame.contains(point)
            else {
                return
        }
        isDragging = true
        originalTouchPoint = point
        originalVolumn = volumeSlider?.value ?? 0
        originalBrightness = UIScreen.main.brightness
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self),
            !playControl.frame.contains(point)
            else {
                return
        }
        
        // 判断滑动方向
        let verDistance = abs(point.y - originalTouchPoint.y)
        let horDistance = abs(point.x - originalTouchPoint.x)
        
        if verDistance > horDistance && !isDraggingHorizontal { // 垂直滑动
            // 判断区域
            if !isFullScreen {
                return
            }
            if originalTouchPoint.x < bounds.width * 0.5 { // 调整音量
                let volumnDelta = (originalTouchPoint.y - point.y) / 300
                let volumn = max(0, Float(volumnDelta) + originalVolumn)
                volumeSlider?.value = volumn
            } else { // 调整亮度
                let brightness = (originalTouchPoint.y - point.y) / 500
                UIScreen.main.brightness = brightness + originalBrightness
            }
        } else { // 调整播放进度
            if horDistance < 5 {
                return
            }
            isDraggingHorizontal = true
            changeProgressTipLabel.isHidden = false
            var delta: Double = Double((point.x - originalTouchPoint.x) / bounds.width) * kChangeProgressMaxValue
            let currentTime = CMTimeGetSeconds(videoPlayer!.currentTime())
            let totalTime = CMTimeGetSeconds(playerItem!.duration)
            if delta + currentTime < 0 {
                delta = 0 - currentTime
            } else if delta + currentTime > totalTime {
                delta = totalTime - currentTime
            }
            let attr = settingChangeProgressTipAttrText(currentTime: delta + currentTime, totalTime: totalTime)
            changeProgressTipLabel.attributedText = attr
            changeProgressResultTime = delta + currentTime
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDraggingHorizontal {
            changeProgressTipLabel.isHidden = true
            // 更新播放进度
            videoPlayer?.seek(to: CMTimeMake(value: Int64(changeProgressResultTime), timescale: 1),
                              toleranceBefore: CMTimeMake(value: 0, timescale: 1),
                              toleranceAfter: CMTimeMake(value: 0, timescale: 1))
        }
        isDragging = false
        isDraggingHorizontal = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDraggingHorizontal {
            changeProgressTipLabel.isHidden = true
            // 更新播放进度
            videoPlayer?.seek(to: CMTimeMake(value: Int64(changeProgressResultTime), timescale: 1),
                              toleranceBefore: CMTimeMake(value: 0, timescale: 1),
                              toleranceAfter: CMTimeMake(value: 0, timescale: 1))
        }
        isDragging = false
        isDraggingHorizontal = false
    }
    
    private func settingChangeProgressTipAttrText(currentTime: Double, totalTime: Double) -> NSAttributedString? {
        let current = currentTime.timeFormatter
        let total = totalTime.timeFormatter
        let attrM = NSMutableAttributedString(string: "\(current)/\(total)")
        attrM.addAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 17 / 255.0, green: 200 / 255.0, blue: 14 / 255.0, alpha: 1.0)],
                            range: NSMakeRange(0, current.count))
        attrM.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white],
                            range: NSMakeRange(current.count, total.count + 1))
        return attrM.copy() as? NSAttributedString
    }
}

// MARK: - Observer
extension LNPlayer {
    /// 监听播放资源
    private func addPlayerItemObserver() {
        guard let item = playerItem else {
            return
        }
        
        // 状态
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        // 缓冲进度
        item.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        // seekToTime 后缓冲数据为空
        item.addObserver(self, forKeyPath: "isPlaybackBufferEmpty", options: .new, context: nil)
        // seekToTime 后数据不为空
        item.addObserver(self, forKeyPath: "isPlaybackBufferFull", options: .new, context: nil)
    }
    
    /// 移除播放资源监听
    private func removePlayerItemObserver() {
        guard let item = playerItem else {
            return
        }
        
        item.removeObserver(self, forKeyPath: "status")
        item.removeObserver(self, forKeyPath: "loadedTimeRanges")
        item.removeObserver(self, forKeyPath: "isPlaybackBufferEmpty")
        item.removeObserver(self, forKeyPath: "isPlaybackBufferFull")
    }
    
    /// KVO 回调
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else {
            return
        }
        
        switch key {
        case "status": // 状态
            if playerItem!.status == .readyToPlay {
                indicator.stopAnimating()
                indicator.isHidden = true
                playButton.isHidden = false
                videoPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0, preferredTimescale: Int32(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] (_) in
                    self?.syncPlayProgress()
                }
            }
        case "loadedTimeRanges": // 缓冲进度
            guard let loadedTimeRanges = playerItem!.loadedTimeRanges.first as? CMTimeRange else {
                return
            }
            let startSeconds = CMTimeGetSeconds(loadedTimeRanges.start)
            let durationSeconds = CMTimeGetSeconds(loadedTimeRanges.duration)
            // 缓冲时长
            let bufferSeconds = startSeconds + durationSeconds
            // 总时长
            let videoSeconds = CMTimeGetSeconds(playerItem!.asset.duration)
            let progress = bufferSeconds / videoSeconds
            // 更新缓冲进度
            playControl.updateBufferProgress(Float(progress))
        default:
            break
        }
    }
}

// MARK: - Player
private extension LNPlayer {
    @objc func play(sender: UIButton) {
        guard let player = videoPlayer else {
            return
        }
        sender.isHidden = true
        isStartPlay = true
        if status == .end {
            player.seek(to: CMTimeMake(value: 0, timescale: 1))
        }
        player.play()
        status = .playing
        playControl.status = .playing
    }
    
    /// 同步播放进度
    func syncPlayProgress() {
        guard let player = videoPlayer, !isChangePlayProgress else {
            return
        }
        
        let duration = playerItem!.duration
        if !duration.isValid {
            return
        }
        
        let seconds = CMTimeGetSeconds(duration)
        let current = CMTimeGetSeconds(player.currentTime())
        playControl.updatePlayProgress(currentTime: current, totalTime: seconds)
    }
    
    /// 播放完成
    @objc func playCompleted() {
        status = .end
        playControl.status = .end
        playButton.isHidden = false
    }
}

// MARK: - LNPlayerControlBarDelegate
extension LNPlayer: LNPlayerControlBarDelegate {
    /// 播放
    func playControlBarStartPlay(_ playControlBar: LNPlayerControlBar) {
        if playerItem?.status == .readyToPlay {
            if status == .end {
                status = .playing
                videoPlayer?.seek(to: CMTimeMake(value: 0, timescale: 1))
            }
            videoPlayer?.play()
            playButton.isHidden = true
        }
    }
    
    /// 暂停
    func playControlBarPause(_ playControlBar: LNPlayerControlBar) {
        videoPlayer?.pause()
        status = .pause
        playButton.isHidden = false
    }
    
    /// 进入全屏
    func playControlBarEnterFullScreen(_ playControlBar: LNPlayerControlBar) {
        originalFrame = frame
        superView = superview
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        UIApplication.shared.cancelAllLocalNotifications()
        originalWindowLevel = window.windowLevel
        window.windowLevel = UIWindow.Level.statusBar + 1
        removeFromSuperview()
        isFullScreen = true
        (UIApplication.shared.delegate as! AppDelegate).blockRotation = .landscape
        UIView.animate(withDuration: 0.25) {
            self.frame = window.bounds
            window.addSubview(self)
        }
    }
    
    /// 退出全屏
    func playControlBarExitFullScreen(_ playControlBar: LNPlayerControlBar) {
        guard let window = UIApplication.shared.keyWindow, let sv = superView else {
            return
        }
        window.windowLevel = originalWindowLevel
        removeFromSuperview()
        sv.addSubview(self)
        isFullScreen = false
        (UIApplication.shared.delegate as! AppDelegate).blockRotation = .portrait
        UIView.animate(withDuration: 0.25) {
            self.frame = self.originalFrame
        }
    }
    
    /// 开始更改播放进度
    func playControlBarStartChangePlayProgress(_ playControlBar: LNPlayerControlBar) {
        isChangePlayProgress = true
    }
    
    func playControlBar(_ playControlBar: LNPlayerControlBar, changedEnd progress: Float) {
        guard let player = videoPlayer else {
            isChangePlayProgress = false
            return
        }
        let value = Int64(Double(progress) * CMTimeGetSeconds(playerItem!.duration))
        player.seek(to: CMTimeMake(value: value, timescale: 1)) { (_) in
            self.isChangePlayProgress = false
        }
    }
}
