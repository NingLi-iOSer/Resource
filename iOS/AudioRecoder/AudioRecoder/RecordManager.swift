//
//  RecordManager.swift
//  AudioRecoder
//
//  Created by Ning Li on 2019/5/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import AVFoundation

/// 播放方式
///
/// - speaker: 扬声器
/// - receiver: 听筒
enum RecordPlayType {
    case speaker
    case receiver
}

protocol RecodManagerDelegate: class {
    /// 录音音量更新回调
    func recordManager(_ manager: RecordManager, update volume: Float)
}

extension RecodManagerDelegate {
    func recordManager(_ manager: RecordManager, update volume: Float) { }
}

/// 录音管理
class RecordManager {
    
    private var delegate: RecodManagerDelegate?
    
    /// 录音器
    private var recorder: AVAudioRecorder?
    /// 播放器
    private var player: AVAudioPlayer?
    /// 录音器设置参数
    private var recorderSettings: [String: Any]
    /// 定时器 - 监测录音音量
    private var volumeTimer: Timer?
    /// 录音存储路径
    private var aacPath: String
    
    /// 初始化
    ///
    /// - Parameter path: 录音文件存储路径
    init(path: String, delegate: RecodManagerDelegate?) {
        self.aacPath = path
        self.delegate = delegate
        
        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
        
        recorderSettings = [AVFormatIDKey: kAudioFormatMPEG4AAC,
                            AVNumberOfChannelsKey: 2,
                            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                            AVEncoderBitRateKey: 128000,
                            AVSampleRateKey: 44100]
    }
    
    /// 开始录音
    func startRecord() {
        if recorder?.isRecording ?? false {
            return
        }
        
        do {
            recorder = try AVAudioRecorder(url: URL(fileURLWithPath: aacPath), settings: recorderSettings)
        } catch let error {
            print("录音失败: \(error.localizedDescription)")
        }
        
        recorder?.isMeteringEnabled = true
        recorder?.prepareToRecord()
        // 开始录音
        recorder?.record()
        settingTimer()
    }
    
    /// 停止录音
    func stopRecord() {
        if recorder?.isRecording ?? false {
            recorder?.stop()
            recorder = nil
            invalidateTimer()
            delegate?.recordManager(self, update: 0)
        }
    }
    
    /// 播放录音
    func play(type: RecordPlayType) {
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: aacPath))
        } catch let error {
            print("播放失败: \(error.localizedDescription)")
        }
        
        if type == .speaker {
            try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } else {
            try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
        }
        player?.play()
    }
    
    /// 提示播放录音
    func stopPlay() {
        player?.stop()
    }
    
    /// 设置定时器
    private func settingTimer() {
        if volumeTimer == nil {
            volumeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(levelTimer), userInfo: nil, repeats: true)
        }
    }
    
    /// 销毁定时器
    private func invalidateTimer() {
        volumeTimer?.invalidate()
        volumeTimer = nil
    }
}

// MARK: - 监听事件
extension RecordManager {
    /// 监测录音音量
    @objc private func levelTimer() {
        // 刷新音量数据
        recorder!.updateMeters()
        // 获取音量最大值
        let maxVolume = recorder!.peakPower(forChannel: 0)
        let lowPassResult = pow(10, 0.05 * maxVolume)
        
        delegate?.recordManager(self, update: lowPassResult)
    }
}
