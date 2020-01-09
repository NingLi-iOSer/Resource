//
//  ViewController.swift
//  AudioRecoder
//
//  Created by Ning Li on 2019/5/16.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {
    
    private var manager: RecordManager?
    
    private var recordFilePath: String = ""
    
    private var times: Float = 0

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var changePlayTypeSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doc = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        recordFilePath = doc + "/play.aac"
        manager = RecordManager(path: recordFilePath, delegate: self)
        
        _ = NETunnelProvider()
    }
    
    /// 开始录音
    @IBAction func startRecord() {
        times = 0
        manager?.startRecord()
    }
    
    /// 结束录音
    @IBAction func stopRecord() {
        manager?.stopRecord()
    }
    
    /// 播放录音
    @IBAction func playRecord() {
        switch changePlayTypeSwitch.isOn {
        case true:
            manager?.play(type: .speaker)
        case false:
            manager?.play(type: .receiver)
        }
    }
    
    @IBAction func loadFile() {
        let fileManager = FileManager.default
        guard let data = fileManager.contents(atPath: recordFilePath) else {
            print("读取文件失败")
            return
        }
        
        sizeLabel.text = "\(data.count / 1024) K"
    }
}

// MARK: - RecodManagerDelegate
extension ViewController: RecodManagerDelegate {
    func recordManager(_ manager: RecordManager, update volume: Float) {
        progressView.progress = volume
        times += 0.1
        timeLabel.text = "\(times)s"
    }
}

