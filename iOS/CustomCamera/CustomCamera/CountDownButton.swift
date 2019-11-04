//
//  CountDownButton.swift
//  PopGesture
//
//  Created by Ning Li on 2019/3/29.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

/// 倒计时按钮
class CountDownButton: UIButton {

    var bgColor: UIColor?
    var disableBGColor = UIColor.white
    
    @IBInspectable var normalTitle: String? {
        didSet {
            setTitle(normalTitle, for: .normal)
        }
    }
    
    private var timer: DispatchSourceTimer?
    private var duration: Int = 0
    
    class func make(textColor: UIColor, bgColor: UIColor, disableBGColor: UIColor, fontSize: CGFloat) -> CountDownButton {
        let button = CountDownButton(textColor: textColor, bgColor: bgColor, disableBGColor: disableBGColor, fontSize: fontSize)
        return button
    }
    
    convenience init(textColor: UIColor, bgColor: UIColor, disableBGColor: UIColor, fontSize: CGFloat) {
        self.init()
        self.setTitle("获取验证码", for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = bgColor
        self.bgColor = bgColor
        self.disableBGColor = disableBGColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    /// 启动倒计时
    ///
    /// - Parameter duration: 时长
    func startCountDown(duration: Int) {
        isUserInteractionEnabled = false
        bgColor = (bgColor == nil) ? backgroundColor : bgColor
        self.duration = duration
        self.backgroundColor = disableBGColor
        if timer == nil {
            timer = GCDTimer.makeTimer(duration: .seconds(1), event: { (timer) in
                if (self.duration >= 0) {
                    self.setTitle("\(self.duration)s", for: .normal)
                    self.duration -= 1
                } else {
                    self.setTitle("重新获取", for: .normal)
                    self.timer?.suspend()
                    self.isUserInteractionEnabled = true
                    self.backgroundColor = self.bgColor
                }
            })
        } else {
            timer?.resume()
        }
    }
    
    private func invalidateTimer() {
        if timer?.isCancelled == false {
            timer?.cancel()
        }
    }
    
    override func removeFromSuperview() {
        invalidateTimer()
        super.removeFromSuperview()
    }
}

/// GCD 定时器
struct GCDTimer {
    
    /// 创建定时器
    ///
    /// - Parameters:
    ///   - duration: 执行间隔时间
    ///   - delay: 延迟时间
    ///   - queue: 执行队列
    ///   - event: event
    @discardableResult
    static func makeTimer(duration: DispatchTimeInterval, delay: DispatchTime = DispatchTime.now(), queue: DispatchQueue = DispatchQueue.main, event: @escaping (_ timer: DispatchSourceTimer) -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(deadline: delay, repeating: duration, leeway: .nanoseconds(0))
        timer.setEventHandler {
            event(timer)
        }
        timer.resume()
        return timer
    }
}
