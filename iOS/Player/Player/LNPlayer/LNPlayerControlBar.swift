//
//  LNPlayerControlBar.swift
//  Player
//
//  Created by Ning Li on 2019/3/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

enum LNPlayerStatus {
    case playing
    case pause
    case end
}

/// 播放控制条
class LNPlayerControlBar: UIView {
    
    weak var delegate: LNPlayerControlBarDelegate?
    
    var status: LNPlayerStatus = .pause {
        didSet {
            switch status {
            case .playing:
                playButton.isSelected = true
            case .pause:
                playButton.isSelected = false
            case .end:
                playButton.isSelected = false
            }
        }
    }
    
    /// 未全屏时的 frame
    private var originalFrame = CGRect()
    
    private let imageBundle = Bundle(path: Bundle.main.path(forResource: "ImageBundle", ofType: "bundle")!)!
    
    private weak var playButton: UIButton!
    /// 缓冲进度条
    private lazy var bufferProgressView: UIProgressView = {
        let v = UIProgressView(progressViewStyle: UIProgressView.Style.default)
        v.trackTintColor = UIColor(red: 80 / 255.0, green: 80 / 255.0, blue: 80 / 255.0, alpha: 1)
        v.progressTintColor = UIColor(red: 160 / 255.0, green: 160 / 255.0, blue: 160 / 255.0, alpha: 1)
        return v
    }()
    /// 播放进度条
    private lazy var playProgressView: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(UIImage(named: "dot", in: imageBundle, compatibleWith: nil), for: .normal)
        slider.minimumTrackTintColor = UIColor(red: 17 / 255.0, green: 200 / 255.0, blue: 14 / 255.0, alpha: 1.0)
        slider.maximumTrackTintColor = UIColor.clear
        slider.minimumValue = 0.02
        slider.maximumValue = 0.98
        slider.value = 0
        slider.addTarget(self, action: #selector(playProgressDidChanged(sender:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(playProgressChangedEnd(sender:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(playProgressChangedEnd(sender:)), for: .touchUpOutside)
        slider.addTarget(self, action: #selector(playProgressChangedEnd(sender:)), for: .touchCancel)
        return slider
    }()
    /// 当前播放时间
    private lazy var currentTimeLabel = UILabel(text: "00:00", frame: CGRect(), fontSize: 12, textColor: UIColor.white)
    /// 总时长
    private lazy var totalTimeLabel = UILabel(text: "00:00", frame: CGRect(), fontSize: 12, textColor: UIColor.white)
    /// 全屏按钮
    private lazy var fullScreenButton = UIButton.imageButton(image: UIImage(named: "fullscreen", in: imageBundle, compatibleWith: nil),
                                                             highlightImage: nil,
                                                             selectedImage: UIImage(named: "nonfullscreen", in: imageBundle, compatibleWith: nil),
                                                             target: self,
                                                             action: #selector(enterOrExitFullScreen(sender:)))
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: 44)))
        settingUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - setting UI
extension LNPlayerControlBar {
    private func settingUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // 播放按钮
        let playButton = UIButton.imageButton(image: UIImage(named: "play", in: imageBundle, compatibleWith: nil),
                                              highlightImage: nil,
                                              selectedImage: UIImage(named: "pause", in: imageBundle, compatibleWith: nil),
                                              target: self,
                                              action: #selector(playOrPause(sender:)))
        playButton.frame = CGRect(origin: CGPoint(x: 20, y: 0), size: playButton.bounds.size)
        addSubview(playButton)
        self.playButton = playButton
        
        addSubview(currentTimeLabel)
        addSubview(bufferProgressView)
        addSubview(playProgressView)
        addSubview(totalTimeLabel)
        addSubview(fullScreenButton)
        fullScreenButton.bounds.size = CGSize(width: 32, height: 32)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playButton.frame.origin.y = (bounds.height - playButton.bounds.height) * 0.5
        currentTimeLabel.frame = CGRect(x: playButton.frame.maxX + 10,
                                        y: (bounds.height - 20) * 0.5,
                                        width: 40,
                                        height: 20)
        bufferProgressView.frame = CGRect(x: currentTimeLabel.frame.maxX + 10,
                                    y: (bounds.height - bufferProgressView.bounds.height) * 0.5,
                                    width: bounds.width - (currentTimeLabel.frame.maxX + 20) * 2 + 20,
                                    height: bufferProgressView.bounds.height)
        playProgressView.frame = bufferProgressView.frame.insetBy(dx: -2, dy: 0)
        totalTimeLabel.frame = currentTimeLabel.frame.offsetBy(dx: bufferProgressView.bounds.width + 20 + currentTimeLabel.bounds.width, dy: 0)
        fullScreenButton.frame = CGRect(origin: CGPoint(x: totalTimeLabel.frame.maxX + 10,
                                                        y: (bounds.height - fullScreenButton.bounds.height) * 0.5),
                                        size: fullScreenButton.bounds.size)
    }
}

// MARK: - 监听事件
private extension LNPlayerControlBar {
    /// 播放 / 暂停
    @objc func playOrPause(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            status = .pause
            delegate?.playControlBarPause(self)
        } else {
            status = .playing
            sender.isSelected = true
            delegate?.playControlBarStartPlay(self)
        }
    }
    
    /// 全屏 / 退出全屏
    @objc func enterOrExitFullScreen(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.playControlBarEnterFullScreen(self)
        } else {
            delegate?.playControlBarExitFullScreen(self)
        }
    }
    
    /// 正在拖动滑块, 更改播放进度
    @objc func playProgressDidChanged(sender: UISlider) {
        delegate?.playControlBarStartChangePlayProgress(self)
    }
    
    /// 停止拖动滑块, 更新播放进度
    @objc func playProgressChangedEnd(sender: UISlider) {
        delegate?.playControlBar(self, changedEnd: sender.value)
    }
}

// MARK: - 公开放大
extension LNPlayerControlBar {
    /// 更新缓冲进度
    ///
    /// - Parameter progress: 缓冲进度
    func updateBufferProgress(_ progress: Float) {
        bufferProgressView.progress = progress
    }
    
    /// 更新播放进度
    ///
    /// - Parameter progress: 播放进度
    func updatePlayProgress(currentTime: Double, totalTime: Double) {
        let minValue = playProgressView.minimumValue
        let maxValue = playProgressView.maximumValue
        currentTimeLabel.text = currentTime.timeFormatter
        totalTimeLabel.text = totalTime.timeFormatter
        let value = (maxValue - minValue) * Float(currentTime / totalTime) + minValue
        playProgressView.value = value
    }
}

extension Double {
    var timeFormatter: String {
        if isNaN {
            return "00:00"
        }
        let min = Int(self / 60)
        let sec = Int(self) % 60
        return String(format: "%02d:%02d", min, sec)
    }
}

extension UIButton {
    class func imageButton(image: UIImage?, highlightImage: UIImage?, selectedImage: UIImage?, target: Any?, action: Selector?) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.setImage(highlightImage, for: .highlighted)
        button.setImage(selectedImage, for: .selected)
        button.sizeToFit()
        guard let target = target,
            let action = action
            else {
                return button
        }
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}

extension UILabel {
    convenience init(text: String?, frame: CGRect, fontSize: CGFloat, textColor: UIColor) {
        self.init(frame: frame)
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
        self.textAlignment = .center
    }
}
