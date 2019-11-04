//
//  GCDTimer.swift
//  PopGesture
//
//  Created by Ning Li on 2019/3/28.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Foundation

struct GCDTimer {
    
    @discardableResult
    static func makeTimer(duration: DispatchTimeInterval, delay: DispatchTime = DispatchTime.now(), queue: DispatchQueue = DispatchQueue.main, event: @escaping (_ timer: DispatchSourceTimer) -> Void) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer.schedule(deadline: delay, repeating: duration, leeway: .nanoseconds(0))
        timer.setEventHandler {
            event(timer)
        }
        timer.activate()
        
        return timer
    }
}
